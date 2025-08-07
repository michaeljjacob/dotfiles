return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  config = function()
    vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
    vim.keymap.set("n", "<leader>db", ":DBUI<CR>", { noremap = true })
  end,
}