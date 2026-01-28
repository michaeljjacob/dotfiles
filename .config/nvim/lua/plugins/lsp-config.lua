return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"jsonls",
				"clangd",
				"denols",
				"eslint",
				"gopls",
				"pyright",
			},

		},
	},
	{
		dependencies = {
			"davidosomething/format-ts-errors.nvim",
		},
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Custom diagnostic handler for TypeScript/Deno errors
			local function custom_diagnostic_handler(err, result, ctx, config)
				if result.diagnostics == nil then
					return
				end

				-- ignore some tsserver diagnostics
				local idx = 1
				while idx <= #result.diagnostics do
					local entry = result.diagnostics[idx]

					local formatter = require("format-ts-errors")[entry.code]
					entry.message = formatter and formatter(entry.message) or entry.message

					-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
					if entry.code == 80001 then
						-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
						table.remove(result.diagnostics, idx)
					else
						idx = idx + 1
					end
				end

				-- Call the default handler with the modified diagnostics
				vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
			end

			-- Configure servers using the new vim.lsp.config API
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				handlers = {
					["textDocument/publishDiagnostics"] = custom_diagnostic_handler,
				},
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					if util.root_pattern("deno.json", "deno.jsonc")(vim.api.nvim_buf_get_name(bufnr)) then
						return
					end
					local root =
						util.root_pattern("package.json", "tsconfig.json", ".git")(vim.api.nvim_buf_get_name(bufnr))
					if root then
						on_dir(root)
					end
				end,
			})

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
			})

			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})

			vim.lsp.config("denols", {
				capabilities = capabilities,
				handlers = {
					["textDocument/publishDiagnostics"] = custom_diagnostic_handler,
				},
				settings = {
					deno = {
						lint = true,
						unstable = true,
					},
				},
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					-- Only start if deno.json/deno.jsonc is found
					local root = util.root_pattern("deno.json", "deno.jsonc")(vim.api.nvim_buf_get_name(bufnr))
					if root then
						on_dir(root)
					end
				end,
			})

			local util = require("lspconfig.util")
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					local fname = vim.api.nvim_buf_get_name(bufnr)
					-- Disable eslint in Deno projects (prioritize denols)
					if util.root_pattern("deno.json", "deno.jsonc")(fname) then
						return
					end
					-- Otherwise, use nearest ESLint/Node project root
					local root = util.root_pattern(".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "package.json", "tsconfig.json", ".git")(fname)
					if root then
						on_dir(root)
					end
				end,
			})

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						usePlaceholders = true,
						staticcheck = true,
             semanticTokens = true,
					},
				},
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = util.root_pattern("go.work", "go.mod", ".git")(fname)
					if root then on_dir(root) end
				end,
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoImportCompletions = true,
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
						},
					},
				},
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = util.root_pattern(
						"pyproject.toml",
						"pyrightconfig.json",
						"setup.cfg",
						"setup.py",
						"requirements.txt",
						".git"
					)(fname)

					if root then
						on_dir(root)
					else
						on_dir(util.path.dirname(fname))
					end
				end,
			})

			-- Enable the configured servers
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("denols")
			-- Disable eslint by default in Deno roots; enable elsewhere via root_dir above
			vim.lsp.enable("eslint")
			vim.lsp.enable("gopls")
			vim.lsp.enable("pyright")


		-- Custom keymaps
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set("n", "<leader>gsd", function()
			vim.cmd("vsplit")
			vim.lsp.buf.definition()
		end, { desc = "Go to definition in vertical split" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		vim.keymap.set("n", "<leader>e", function()
			vim.diagnostic.open_float(nil, { focus = false })
		end, {})
		
		-- Focus any floating window (LSP hover, diagnostics, etc.)
		vim.keymap.set("n", "<leader>fw", function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then  -- It's a floating window
					vim.api.nvim_set_current_win(win)
					return
				end
			end
			vim.notify("No floating window found", vim.log.levels.WARN)
		end, { desc = "Focus floating window" })

			-- Diagnostic configuration
			vim.diagnostic.config({
				float = {
					source = "always",
				},
			})
		end,
	},
}
