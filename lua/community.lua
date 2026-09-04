-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.
--
-- Carry-over file #2 (with lua/plugins/user.lua). Drop both onto a fresh
-- template; no edits to lazy_setup.lua or any other scaffolding needed.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.full-dadbod" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.godot" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.ruby" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.elixir" },
  -- { import = "astrocommunity.pack.odin" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.search.nvim-spectre" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.programming-language-support.rest-nvim" },
}
