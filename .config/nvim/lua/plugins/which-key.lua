return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      preset = "modern",
      delay = 999999, -- Effectively disable auto-popup (only show with <leader>?)
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
    })
    
    -- Register keybind descriptions
    wk.add({
      -- Leader key groups (high priority)
      { "<leader>b", desc = "Browse files (Neo-tree)", icon = "󰙅" },
      
      -- Find group (Telescope)
      { "<leader>f", group = "Find", icon = "" },
      { "<leader>ff", desc = "Find files", icon = "" },
      { "<leader>fg", desc = "Live grep search", icon = "" },
      { "<leader>fw", desc = "Focus floating window", icon = "󰖲" },
      
      -- Git operations group
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>gb", desc = "Toggle line blame", icon = "󰊢" },
      { "<leader>gwd", desc = "Toggle word diff", icon = "󰦓" },
      { "<leader>gf", desc = "Format buffer/selection", icon = "" },
      
      -- Diff view group
      { "<leader>d", group = "Diff", icon = "" },
      { "<leader>do", desc = "Open diff vs main", icon = "" },
      { "<leader>dc", desc = "Close diff view", icon = "" },
      { "<leader>dh", desc = "File history (current)", icon = "" },
      
      -- Database group
      { "<leader>db", desc = "Database UI", icon = "" },
      
      -- Opencode AI assistant group
      { "<leader>o", group = "Opencode (AI)", icon = "󰧑" },
      { "<leader>oa", desc = "Ask opencode", icon = "󰭹" },
      { "<leader>ox", desc = "Execute action", icon = "⚡" },
      { "<leader>oc", desc = "Toggle terminal", icon = "" },
      
      -- Code actions & diagnostics
      { "<leader>c", group = "Code", icon = "" },
      { "<leader>ca", desc = "Code actions", icon = "💡" },
      { "<leader>e", desc = "Show diagnostics", icon = "" },
      
      -- Manual trigger for which-key itself
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Show all keybinds", icon = "❓" },
      
      -- LSP navigation (g prefix)
      { "g", group = "Go to / LSP", icon = "󰞘" },
      { "gd", desc = "Go to definition", icon = "󰼭" },
      { "gD", desc = "Go to declaration", icon = "󰼭" },
      { "<leader>gsd", desc = "Go to definition in vertical split", icon = "󰼭" },
      { "go", desc = "Add range to opencode", icon = "󰒕", mode = { "n", "x" } },
      { "goo", desc = "Add line to opencode", icon = "󰒕" },
      
      -- Hover documentation
      { "K", desc = "Hover documentation", icon = "󰋖" },
      
      -- Window/Tmux navigation
      { "<C-h>", desc = "Navigate left (Tmux)", icon = "" },
      { "<C-j>", desc = "Navigate down (Tmux)", icon = "" },
      { "<C-k>", desc = "Navigate up (Tmux)", icon = "" },
      { "<C-l>", desc = "Navigate right (Tmux)", icon = "" },
      
      -- Insert mode mappings (lower priority - at bottom)
      { mode = "i", group = "Insert Mode" },
      { "<C-Space>", desc = "Trigger completion", mode = "i", icon = "󰄾" },
      { "<Tab>", desc = "Next item / snippet", mode = "i", icon = "󰌒" },
      { "<CR>", desc = "Confirm selection", mode = "i", icon = "󰌑" },
      { "<C-e>", desc = "Abort completion / Clear AI", mode = "i", icon = "" },
      { "<C-k>", desc = "Accept AI suggestion", mode = "i", icon = "✓" },
      { "<C-b>", desc = "Scroll docs up", mode = "i", icon = "" },
      { "<C-f>", desc = "Scroll docs down", mode = "i", icon = "" },
      
      -- Visual mode mappings
      { mode = "v", group = "Visual Mode" },
      { "<leader>gf", desc = "Format selection", mode = "v", icon = "" },
      { "<leader>oa", desc = "Ask opencode", mode = "v", icon = "󰭹" },
      { "<leader>ox", desc = "Execute action", mode = "v", icon = "⚡" },
      { "go", desc = "Add range to opencode", mode = "v", icon = "󰒕" },
    })
  end,
}
