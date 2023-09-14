return {
	"neovim/nvim-lspconfig",
	event = "VimEnter",
	dependencies = {
		"pmizio/typescript-tools.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")

		-- Load Lua LSP for Neovim
		lspconfig.lua_ls.setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
						Lua = {
							runtime = {
								version = "LuaJIT"
							},
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true)
							}
						}
					})

					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end

				return true
			end
		})

		-- Load Nix LSP for nix-darwin
		lspconfig.rnix.setup({})

		-- Handles tsserver in binary format
		require("typescript-tools").setup({})
		lspconfig.cssls.setup({})
		lspconfig.html.setup({})
		lspconfig.svelte.setup({})

		-- Adds EslintFixAll
		lspconfig.eslint.setup({
			settings = {
				packageManager = "pnpm"
			}
		})

		-- Native Languages
		lspconfig.clangd.setup({})
		lspconfig.sourcekit.setup({})
		lspconfig.rust_analyzer.setup({})

		-- Manifests
		lspconfig.jsonls.setup({})
		lspconfig.yamlls.setup({
			settings = {
				yaml = {
					keyOrdering = false
				}
			}
		})

		-- Format code on save unless written with :Wf
		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Format on Save",
			callback = function()
				local client = vim.lsp.get_active_clients({ name = "eslint" })

				if client and #client > 0 then
					vim.cmd("silent! EslintFixAll")
				else
					vim.lsp.buf.format({ async = false })
					vim.cmd("silent! write")
				end
			end,
			pattern = { "*" }
		})

		vim.g.bind_keys({
			{ { "n" }, "<Leader>vd",  function() vim.diagnostic.open_float() end },
			{ { "n" }, "<Leader>vws", function() vim.lsp.buf.workspace_symbol() end },
			{ { "n" }, "<Leader>vca", function() vim.lsp.buf.code_action() end },
			{ { "v" }, "<Leader>vca", function() vim.lsp.buf.range_code_action() end },
			{ { "n" }, "<Leader>rn",  function() vim.lsp.buf.rename() end },
			{ { "n" }, "gD",          function() vim.lsp.buf.declaration() end },
			{ { "n" }, "go",          function() vim.lsp.buf.type_definition() end },
			{ { "i" }, "<C-h>",       function() vim.lsp.buf.signature_help() end },
			{ { "n" }, "K",           function() vim.lsp.buf.hover() end },
			{ { "n" }, "]d",          function() vim.diagnostic.goto_prev() end },
			{ { "n" }, "[d",          function() vim.diagnostic.goto_next() end }
		})

		-- Command to save without formatting
		vim.api.nvim_create_user_command('Wf', function()
			vim.opt.eventignore = { "BufWritePre" }
			vim.cmd("silent! write")
			vim.opt.eventignore = {}
		end, {})
	end
}
