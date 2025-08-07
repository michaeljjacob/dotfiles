return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
          local telescope = require("telescope")
          local themes = require("telescope.themes")  
          local builtin = require("telescope.builtin")


            telescope.setup({
                extensions = {
                    ["ui-select"] = themes.get_dropdown({})
                }
            })

            telescope.load_extension("ui-select")

            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
    }
}
