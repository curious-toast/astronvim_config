return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        i = {
          ["<C-\\>"] = { "<Esc>" .. "<Cmd>ToggleTerm<CR>", desc = "Toggle term" },
          ["<M-c>"] = { "<Esc>", desc = "Exit insert mode" },
          -- ["<C-s>"] = { "<Cmd>w<CR>", desc = "Save file" },
          -- ["<C-q>"] = { "<Cmd>q<CR>", desc = "Quit file" },
          -- ["<C-a>"] = { "<Cmd>normal! ggVG<CR>", desc = "Select all" },
          -- ["<C-x>"] = { "<Cmd>normal! dd<CR>", desc = "Cut line" },
          -- ["<C-c>"] = { "<Cmd>normal! y$<CR>", desc = "Copy line" },
          -- ["<C-v>"] = { "<Cmd>normal! p<CR>", desc = "Paste line" },
          -- ["<C-z>"] = { "<Cmd>undo<CR>", desc = "Undo" },
          -- ["<C-y>"] = { "<Cmd>redo<CR>", desc = "Redo" },
          -- ["<C-f>"] = { "<Cmd>normal! <C-f><CR>", desc = "Page down" },
          -- ["<C-b>"] = { "<Cmd>normal! <C-b><CR>", desc = "Page up" },
          -- ["<C-d>"] = { "<Cmd>normal! <C-d><CR>", desc = "Scroll down" },
          -- ["<C-u>"] = { "<Cmd>normal! <C-u><CR>", desc = "Scroll up" },
          -- ["<C-j>"] = { "<Cmd>normal! <C-d><CR>", desc = "Scroll down" },
          -- ["<C-k>"] = { "<Cmd>normal! <C-u><CR>", desc = "Scroll up" },
          -- ["<C-l>"] = { "<Cmd>normal! <C-l><CR>", desc = "Redraw screen" },
          -- ["<C-h>"] = { "<Cmd>normal! <C-h><CR>", desc = "Backspace" },
          -- ["<C-n>"] = { "<Cmd>normal! <C-n><CR>", desc = "Next line" },
          -- ["<C-p>"] = { "<Cmd>normal! <C-p><CR>", desc = "Previous line" },
          -- ["<C-e>"] = { "<Cmd>normal! <C-e><CR>", desc = "Scroll}
        },
        -- first key is the mode
        n = {
          -- Buffer nav
          ["<S-h>"] = { "<cmd>bNext<cr>", desc = "Prev tab" },
          ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next tab" },
          -- Terminal
          ["<C-\\>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" },
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with the `name` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { name = "Buffers" },
          -- quick save
          -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        },
        t = {
          ["<C-\\>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function() vim.lsp.buf.hover() end,
            desc = "Hover symbol details",
          },
          -- condition for only server with declaration capabilities
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
    },
  },
}
