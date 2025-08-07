return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    opts = {
      mappings = {
        complete = {
          insert = "<Tab>",
        },
        reset = {
          insert = "<C-r>",
          normal = "<C-r>",
        }

      },
      window = {
        layout = "vertical", -- vertical split layout
        width = 0.3,     -- 50% of editor width
        height = 0.5,    -- 50% of editor height
      },
      question_header = "  ",
      answer_header = "  ",
      error_header = "  ",
    },
    config = function(_, opts)
      -- Configure vertical splits to open on the right
      vim.o.splitright = true
      vim.cmd("Copilot disable")

      -- Setup CopilotChat with provided options
      require("CopilotChat").setup(opts)

      -- Keymap to open CopilotChat
      -- Keymap to open CopilotCha bt
      vim.keymap.set({ "n", "v" }, "<leader>cc", function()
        require("CopilotChat").toggle(opts)
      end, { noremap = true, silent = true })

      vim.keymap.set({ "n", "v" }, "<leader>cm", ":CopilotChatModel<CR>", { noremap = true, silent = true })
    end,
  },
}
