return {
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "cspell",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "davidmh/cspell.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local cspell = require("cspell")

      null_ls.setup({
        sources = {
          -- existing formatters
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier.with({
            extra_args = { "--config-precedence", "prefer-file" },
            cwd = function(params)
              -- Look for monorepo root (e.g., where .git or package.json exists)
              return require("lspconfig.util").root_pattern("package.json", ".git")(params.bufname)
            end,
          }),
          -- cSpell for diagnostics and code actions
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.HINT
            end,
          }),
          cspell.code_actions,
        },

        -- keymaps for formatting
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" }),
        vim.keymap.set("v", "<leader>gf", function()
          vim.lsp.buf.format({
            range = {
              ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
              ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
            }
          })
        end, { desc = "Format selection" }),
      })
    end,
  },
}
