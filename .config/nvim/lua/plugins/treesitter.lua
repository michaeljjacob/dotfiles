return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "javascript", "typescript" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
