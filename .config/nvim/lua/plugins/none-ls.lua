return {
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "eslint_d",
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
      local extras = require("none-ls.diagnostics.eslint_d")
      local eslint_d_formatting = require("none-ls.formatting.eslint_d")
      local eslint_d_code_actions = require("none-ls.code_actions.eslint_d")
      local lsp_util = require("lspconfig.util")
      local cspell = require("cspell")

      local eslint_d_root = function(params)
        if lsp_util.root_pattern("deno.json", "deno.jsonc")(params.bufname) then
          return nil
        end
        return lsp_util.root_pattern(
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "eslint.config.ts",
          "eslint.config.mts",
          "eslint.config.cts",
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.json",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          "package.json",
          "tsconfig.json",
          ".git"
        )(params.bufname)
      end

      local eslint_d_enabled = function(params)
        return lsp_util.root_pattern("deno.json", "deno.jsonc")(params.bufname) == nil
      end

      local has_yamlfmt = vim.fn.executable("yamlfmt") == 1

      local yaml_formatters = {}
      if has_yamlfmt then
        table.insert(yaml_formatters, null_ls.builtins.formatting.yamlfmt)
      end

      null_ls.setup({
        sources = vim.list_extend({
          extras.with({
            cwd = eslint_d_root,
            condition = eslint_d_enabled,
            extra_args = { "--no-warn-ignored" },
          }),
          eslint_d_formatting.with({ cwd = eslint_d_root, condition = eslint_d_enabled }),
          eslint_d_code_actions.with({ cwd = eslint_d_root, condition = eslint_d_enabled }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd.with({
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
