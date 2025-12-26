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
        "prettierd",
        "yamlfmt",
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

      local has_prettierd = vim.fn.executable("prettierd") == 1
      local has_prettier = vim.fn.executable("prettier") == 1
      local has_yamlfmt = vim.fn.executable("yamlfmt") == 1

      local yaml_formatters = {}
      if has_prettierd then
        table.insert(yaml_formatters, null_ls.builtins.formatting.prettierd)
      elseif has_prettier then
        table.insert(yaml_formatters, null_ls.builtins.formatting.prettier)
      end
      if has_yamlfmt then
        table.insert(yaml_formatters, null_ls.builtins.formatting.yamlfmt)
      end

      null_ls.setup({
        sources = vim.list_extend({
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier.with({
            extra_args = { "--config-precedence", "prefer-file" },
            cwd = function(params)
              return require("lspconfig.util").root_pattern("package.json", ".git")(params.bufname)
            end,
          }),
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.HINT
            end,
          }),
          cspell.code_actions,
        }, yaml_formatters),
      })

      vim.keymap.set("n", "<leader>gf", function()
        vim.lsp.buf.format({ async = false })
      end, { desc = "Format buffer" })
      vim.keymap.set("v", "<leader>gf", function()
        vim.lsp.buf.format({
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
          async = false,
        })
      end, { desc = "Format selection" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.yml", "*.yaml" },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
        group = vim.api.nvim_create_augroup("YamlFormatOnSave", { clear = true }),
      })
    end,
  },
}
