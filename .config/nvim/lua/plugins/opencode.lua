return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      local user_opts = type(vim.g.opencode_opts) == "table" and vim.g.opencode_opts or {}

      local opts = vim.tbl_deep_extend("force", {
        port = 3333,
        provider = {
          enabled = "tmux",
          tmux = {
            options = "-h -c '#{pane_current_path}'",
          },
        },
      }, user_opts)

      opts.provider.cmd = opts.provider.cmd or string.format("opencode --port %s", opts.port)

      vim.g.opencode_opts = opts
      vim.o.autoread = true

      local opencode = require("opencode")
      local map_opts = { noremap = true, silent = true }

      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        opencode.ask("@this: ", { submit = true })
      end, vim.tbl_extend("force", { desc = "Ask opencode" }, map_opts))

      vim.keymap.set({ "n", "x" }, "<leader>ox", function()
        opencode.select()
      end, vim.tbl_extend("force", { desc = "Execute opencode action…" }, map_opts))

      vim.keymap.set({ "n", "t" }, "<leader>oc", function()
        opencode.toggle()
      end, vim.tbl_extend("force", { desc = "Toggle opencode" }, map_opts))

      vim.keymap.set({ "n", "x" }, "go", function()
        return opencode.operator("@this ")
      end, { expr = true, desc = "Add range to opencode", silent = true })

      vim.keymap.set("n", "goo", function()
        return opencode.operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode", silent = true })

      vim.keymap.set("n", "<S-C-u>", function()
        opencode.command("session.half.page.up")
      end, vim.tbl_extend("force", { desc = "opencode half page up" }, map_opts))

      vim.keymap.set("n", "<S-C-d>", function()
        opencode.command("session.half.page.down")
      end, vim.tbl_extend("force", { desc = "opencode half page down" }, map_opts))
    end,
  },
}
