return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "javascript", "json", "jsonc", "typescript", "go", "gomod", "gowork", "gosum" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
