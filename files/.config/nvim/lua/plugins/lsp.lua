local function lsp(name, options)
	-- If name is an array of strings, then loop through with blank options
	if type(name) == "table" then
		for _, v in ipairs(name) do
			lsp(v)
		end

		return
	end

	require("lspconfig")[name].setup(options or {})
end

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- These are done manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		keys = {
			{ "<Leader>vca", vim.lsp.buf.code_action,       desc = "View code actions" },
			{ "<Leader>vca", vim.lsp.buf.range_code_action, desc = "View code actions",               mode = "v" },
			{ "<Leader>rn",  vim.lsp.buf.rename,            desc = "Rename symbol" },
			{ "<Leader>go",  vim.lsp.buf.type_definition,   desc = "Go to type definition" },
			{ "K",           vim.lsp.buf.hover,             desc = "View symbol information as popup" },
			{ "]d",          vim.diagnostic.goto_prev,      desc = "Go to previous LSP diagnostic" },
			{ "[d",          vim.diagnostic.goto_next,      desc = "Go to next LSP diagnostic" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			vim.diagnostic.config({
				virtual_text = true,
				float = { source = "always" }
			})

			lsp({ "clangd", "cssls", "html", "rnix", "svelte", "tsserver", "rust_analyzer" })

			lsp("eslint", {
				settings = {
					packageManager = "pnpm",
				},
			})

			lsp("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
						},
					},
				}
			})

			lsp("jdtls", {
				cmd = {
					"jdt-language-server",
					"-data",
					vim.fn.expand("~/.cache/jdtls/workspace"),
				},
			})

			lsp("yamlls", {
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			})

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
				pattern = { "*" },
			})

			-- Command to save without formatting
			vim.api.nvim_create_user_command("Wf", function()
				vim.opt.eventignore = { "BufWritePre" }
				vim.cmd("write")
				vim.opt.eventignore = {}
			end, {})
		end,
	},
}
