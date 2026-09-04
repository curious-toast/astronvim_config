-- =============================================================================
-- User config — all customizations live here.
--
-- On a template re-scaffold, carry over just TWO files (pure file drop, no
-- edits to any scaffolding):
--   1. this file        (lua/plugins/user.lua) — every plugin/config tweak
--   2. lua/community.lua — community pack list (imported by lazy_setup.lua)
--
-- lazy.nvim loads every file in lua/plugins/ and merges specs that target the
-- same plugin, so this file can override the template stubs (astrolsp, mason,
-- treesitter, none-ls) without editing them. Leave the stubs pristine.
-- =============================================================================

-- --- diagnostics-yank feature ------------------------------------------------
-- Yank LSP diagnostics to the system clipboard.
--
--   <Leader>ly  current buffer
--   <Leader>lY  every loaded buffer
--
-- Output is one entry per diagnostic, with the offending source line beneath
-- it, so pasted output is readable without the file open alongside it.

---@param bufnr integer
---@param lnum integer 0-indexed
---@return string
local function source_line(bufnr, lnum)
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum, lnum + 1, false)
  if not ok or not lines or not lines[1] then return "" end
  return vim.trim(lines[1])
end

---@param diagnostics vim.Diagnostic[]
---@return string[]
local function format_diagnostics(diagnostics)
  table.sort(diagnostics, function(a, b)
    if a.bufnr ~= b.bufnr then return a.bufnr < b.bufnr end
    if a.lnum ~= b.lnum then return a.lnum < b.lnum end
    return a.col < b.col
  end)

  local lines = {}
  for _, d in ipairs(diagnostics) do
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ":.")
    local severity = vim.diagnostic.severity[d.severity] or "UNKNOWN"

    -- "rustc E0381" / "clippy needless_return" / bare source when there's no code
    local tag = d.source or "lsp"
    if d.code then tag = tag .. " " .. tostring(d.code) end

    table.insert(
      lines,
      string.format("%s:%d:%d: %s [%s] %s", path, d.lnum + 1, d.col + 1, severity, tag, d.message:gsub("\n", " "))
    )

    local src = source_line(d.bufnr, d.lnum)
    if src ~= "" then table.insert(lines, "    " .. src) end
  end
  return lines
end

---@param scope "buffer"|"all"
local function yank_diagnostics(scope)
  local diagnostics = scope == "buffer" and vim.diagnostic.get(0) or vim.diagnostic.get()

  if #diagnostics == 0 then
    vim.notify("No diagnostics" .. (scope == "buffer" and " in this buffer" or ""), vim.log.levels.INFO)
    return
  end

  local counts = {}
  for _, d in ipairs(diagnostics) do
    local name = vim.diagnostic.severity[d.severity] or "UNKNOWN"
    counts[name] = (counts[name] or 0) + 1
  end

  local text = table.concat(format_diagnostics(diagnostics), "\n")
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)

  local summary = {}
  for _, name in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
    if counts[name] then table.insert(summary, counts[name] .. " " .. name:lower()) end
  end
  vim.notify("Yanked " .. table.concat(summary, ", "), vim.log.levels.INFO)
end

---@type LazySpec
return {
  -- --- Colorscheme -----------------------------------------------------------
  {
    "tahayvr/matteblack.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme "matteblack" end,
  },

  -- --- Alpha dashboard header ------------------------------------------------
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.section.header.val = {
        [[  =ccccc,      ,cccc       ccccc      ,cccc,  ?$$$$$$$,  ,ccc,   -ccc          ]],
        [[ :::"$$$$bc    $$$$$     ::`$$$$$c,  : $$$$$c`:"$$$$???'`."$$$$c,:`?$$c        ]],
        [[ `::::"?$$$$c,z$$$$F     `:: ?$$$$$c,`:`$$$$$h`:`?$$$,` :::`$$$$$$c,"$$h,      ]],
        [[   `::::."$$$$$$$$$'    ..,,,:"$$$$$$h, ?$$$$$$c`:"$$$$$$$b':"$$$$$$$$$$$c     ]],
        [[      `::::"?$$$$$$    :"$$$$c:`$$$$$$$$d$$$P$$$b`:`?$$$c : ::`?$$c "?$$$$h,   ]],
        [[        `:::.$$$$$$$c,`::`????":`?$$$E"?$$$$h ?$$$.`:?$$$h..,,,:"$$$,:."?$$$c  ]],
        [[          `: $$$$$$$$$c, ::``  :::"$$$b `"$$$ :"$$$b`:`?$$$$$$$c``?$F `:: "::  ]],
        [[           .,$$$$$"?$$$$$c,    `:::"$$$$.::"$.:: ?$$$.:.???????" `:::  ` ```   ]],
        [[           'J$$$$P'::"?$$$$h,   `:::`?$$$c`::``:: .:: : :::::''   `            ]],
        [[          :,$$$$$':::::`?$$$$$c,  ::: "::  ::  ` ::'   ``                      ]],
        [[         .'J$$$$F  `::::: .::::    ` :::'  `                                   ]],
        [[        .: ???):     `:: :::::                                                 ]],
        [[        : :::::'        `                                                      ]],
        [[         ``                                                                    ]],
      }
    end,
  },

  -- --- AstroLSP (features, formatting, servers, autocmds, mappings) ----------
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      features = {
        autoformat = true,
        codelens = true,
        inlay_hints = false,
        semantic_tokens = true,
      },
      formatting = {
        format_on_save = {
          enabled = false,
          allow_filetypes = {},
          ignore_filetypes = {},
        },
        disabled = {},
        timeout_ms = 1000,
      },
      -- Add your GDScript server name here
      servers = {
        "gdscript",
      },
      config = {
        gdscript = {
          cmd = { "nc", "127.0.0.1", "6005" },
          filetypes = { "gd", "gdscript", "gdscript3" },
          root_dir = require("lspconfig.util").root_pattern("project.godot"),
        },
        ols = {
          -- defaults are fine; uncomment to customize
          -- init_options = {
          --   checker_args = "-strict-style",
          --   collections = {
          --     { name = "shared", path = vim.fn.expand "$HOME/odin-lib" },
          --   },
          -- },
        },
      },
      handlers = {},
      autocmds = {
        lsp_document_highlight = {
          cond = "textDocument/documentHighlight",
          {
            event = { "CursorHold", "CursorHoldI" },
            desc = "Document Highlighting",
            callback = function() vim.lsp.buf.document_highlight() end,
          },
          {
            event = { "CursorMoved", "CursorMovedI", "BufLeave" },
            desc = "Document Highlighting Clear",
            callback = function() vim.lsp.buf.clear_references() end,
          },
        },
      },
      mappings = {
        n = {
          gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
          K = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details" },
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
      on_attach = function(client, bufnr) end,
    },
  },

  -- --- Mason (LSP + null-ls installs) ----------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "ols",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "prettier",
        "stylua",
      })
    end,
  },

  -- --- Treesitter parsers ----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua",
        "vim",
        "odin",
      })
    end,
  },

  -- --- None-ls sources -------------------------------------------------------
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, config)
      local null_ls = require "null-ls"
      config.sources = {
        null_ls.builtins.formatting.erb_format,
      }
      return config
    end,
  },

  -- --- Mappings (AstroCore) --------------------------------------------------
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        i = {
          ["<C-\\>"] = { "<Esc>" .. "<Cmd>ToggleTerm<CR>", desc = "Toggle term" },
          ["<M-c>"] = { "<Esc>", desc = "Exit insert mode" },
        },
        n = {
          -- Buffer nav
          ["<S-h>"] = { "<cmd>bNext<cr>", desc = "Prev tab" },
          ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next tab" },
          -- Terminal
          ["<C-\\>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" },
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          ["<Leader>b"] = { name = "Buffers" },
          -- diagnostics-yank
          ["<Leader>ly"] = { function() yank_diagnostics "buffer" end, desc = "Yank buffer diagnostics" },
          ["<Leader>lY"] = { function() yank_diagnostics "all" end, desc = "Yank all diagnostics" },
        },
        t = {
          ["<C-\\>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
        },
      },
    },
  },
}
