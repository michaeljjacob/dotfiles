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
      local eslint_d_code_actions = require("none-ls.code_actions.eslint_d")
      local lsp_util = require("lspconfig.util")
      local cspell = require("cspell")
      local null_ls_sources = require("null-ls.sources")

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

      local function is_deno_project(bufname)
        return lsp_util.root_pattern("deno.json", "deno.jsonc")(bufname) ~= nil
      end

      local function has_prettier_config(bufname)
        local root = lsp_util.root_pattern(
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yaml",
          ".prettierrc.yml",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.mjs",
          "prettier.config.js",
          "prettier.config.cjs",
          "prettier.config.mjs",
          "package.json"
        )(bufname)

        if not root then
          return false
        end

        local config_files = {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yaml",
          ".prettierrc.yml",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.mjs",
          "prettier.config.js",
          "prettier.config.cjs",
          "prettier.config.mjs",
          "package.json",
        }

        for _, name in ipairs(config_files) do
          local path = root .. "/" .. name
          if vim.fn.filereadable(path) == 1 then
            if name == "package.json" then
              local ok, lines = pcall(vim.fn.readfile, path)
              if ok then
                local content = table.concat(lines, "\n")
                if content:find('"prettier"%s*:') then
                  return true
                end
              end
            else
              return true
            end
          end
        end

        return false
      end

      local function get_null_ls_formatters(bufnr, method)
        local sources = null_ls_sources.get_available(vim.bo[bufnr].filetype, method)
        local names = {}
        for _, source in ipairs(sources) do
          if source.name then
            table.insert(names, source.name)
          end
        end
        table.sort(names)
        return names
      end

      local function format_with_notification(opts)
        opts = opts or {}
        local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
        local method = opts.range and "textDocument/rangeFormatting" or "textDocument/formatting"
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local available = {}

        for _, client in ipairs(clients) do
          if client.supports_method(method) then
            table.insert(available, client)
          end
        end

        if #available == 0 then
          vim.notify("No formatter available", vim.log.levels.WARN)
          return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local null_ls_method = opts.range and null_ls.methods.RANGE_FORMATTING or null_ls.methods.FORMATTING
        local null_ls_formatters = get_null_ls_formatters(bufnr, null_ls_method)
        local has_prettierd = vim.tbl_contains(null_ls_formatters, "prettierd")

        local preferred_name = nil
        if has_prettier_config(bufname) and has_prettierd then
          preferred_name = "null-ls"
        elseif is_deno_project(bufname) then
          preferred_name = "denols"
        else
          for _, client in ipairs(available) do
            if client.name == "null-ls" then
              preferred_name = "null-ls"
              break
            end
          end
        end

        preferred_name = preferred_name or available[1].name

        vim.lsp.buf.format(vim.tbl_extend("force", opts, {
          filter = function(client)
            return client.name == preferred_name
          end,
        }))

        local message = nil
        if preferred_name == "null-ls" then
          if #null_ls_formatters == 0 then
            message = "Formatted with: null-ls"
          else
            message = "Formatted with: null-ls (" .. table.concat(null_ls_formatters, ", ") .. ")"
          end
        else
          message = "Formatted with: " .. preferred_name
        end

        vim.notify(message, vim.log.levels.INFO)
      end

      local has_yamlfmt = vim.fn.executable("yamlfmt") == 1

      local yaml_formatters = {}
      if has_yamlfmt then
        table.insert(
          yaml_formatters,
          null_ls.builtins.formatting.yamlfmt.with({
            condition = function(params)
              return not has_prettier_config(params.bufname)
            end,
          })
        )
      end

      null_ls.setup({
        sources = vim.list_extend({
          extras.with({
            cwd = eslint_d_root,
            condition = eslint_d_enabled,
            extra_args = { "--no-warn-ignored" },
          }),
          eslint_d_code_actions.with({ cwd = eslint_d_root, condition = eslint_d_enabled }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd.with({
            extra_args = { "--config-precedence", "prefer-file" },
            condition = function(params)
              return has_prettier_config(params.bufname)
            end,
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
        format_with_notification({ async = false })
      end, { desc = "Format buffer" })
      vim.keymap.set("n", "<leader>fd", function()
        format_with_notification({ async = false })
      end, { desc = "Format buffer" })
      vim.keymap.set("v", "<leader>gf", function()
        format_with_notification({
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
          async = false,
        })
      end, { desc = "Format selection" })
      vim.keymap.set("v", "<leader>fd", function()
        format_with_notification({
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
          format_with_notification({ async = false })
        end,
        group = vim.api.nvim_create_augroup("YamlFormatOnSave", { clear = true }),
      })
    end,
  },
}
