-- This is going to be an unnaturally big file
-- It completely implements LSP and completions
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

-- This only exists for Lua LSP having autocomplete for Neovim Lua
-- The API is huge and referencing the poor documentation is painful
local function nvim_lsp(client)
	client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	})

	client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	return true
end

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		lazy = true,
		dependencies = {
			{
				"stevearc/conform.nvim",
				event = "BufWritePre",
				cmd = "ConformInfo",
				enabled = false,
				opts = {
					format_on_save = {
						timeout_ms = 500,
						lsp_fallback = true,
					},

					formatters_by_ft = {
						javascript = { "eslint" },
						typescript = { "eslint" },
						javascriptreact = { "eslint" },
						typescriptreact = { "eslint" },
						lua = { "stylua" },

						["*"] = { "trim_whitespace", "trim_newlines" },
					},
				},
			},
			{ "hrsh7th/cmp-nvim-lsp", lazy = true },
			"pmizio/typescript-tools.nvim",
			"simrat39/rust-tools.nvim",
			"b0o/schemastore.nvim",
		},
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
			-- Manually declaring LSP servers that I need instead of auto-installing
			lsp({ "clangd", "cssls", "html", "rnix", "sourcekit", "svelte" })

			require("typescript-tools").setup({})
			require("rust-tools").setup({})

			lsp("eslint", {
				settings = {
					packageManager = "pnpm",
				},
			})

			lsp("lua_ls", {
				on_init = nvim_lsp,
			})

			lsp("jdtls", {
				cmd = {
					"jdt-language-server",
					"-data",
					vim.fn.expand("~/.cache/jdtls/workspace"),
				},
			})

			lsp("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = {
							enable = true,
						},
					},
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

			-- Extend the default supported capabilities of LSP
			local cmp_defaults = require("cmp_nvim_lsp").default_capabilities()
			local lsp_defaults = require("lspconfig").util.default_config.capabilities
			lsp_defaults.capabilities = vim.tbl_deep_extend("force", lsp_defaults, cmp_defaults)

			vim.diagnostic.config({
				virtual_text = true,
				float = { source = "always" }
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				opts = {
					panel = { enabled = false },
					suggestion = {
						auto_trigger = true,
						keymap = {
							accept = "<M-CR>",
							accept_word = false,
							accept_line = false,
							next = "<M-]>",
							prev = "<M-[>",
							dismiss = "<C-]>",
						},
					},
					filetypes = { yaml = true, markdown = true },
				},
			},
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local select_opts = { behavior = cmp.SelectBehavior.Select }
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer",  keyword_length = 2 },
				},
				mapping = {
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
					["<C-n>"] = cmp.mapping.select_next_item(select_opts),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
				},
			})
		end,
	},
}
