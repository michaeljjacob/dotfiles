return {
  "sindrets/diffview.nvim",
  config = function()
    local actions = require("diffview.actions")

    require("diffview").setup({
      -- You can customize keymaps and other settings here if needed
      keymaps = {
        view = {
          -- The default keymaps are quite extensive, but you can override them here
          ["q"] = actions.close, 
        },
        file_panel = {
          ["q"] = actions.close,
        },
      },
    })

    -- Keymaps for easier access
    vim.keymap.set("n", "<leader>do", ":DiffviewOpen main<CR>", { desc = "Diff View Open (vs main)" })
    vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Diff View Close" })
    vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory %<CR>", { desc = "Diff View File History" })
  end,
}
