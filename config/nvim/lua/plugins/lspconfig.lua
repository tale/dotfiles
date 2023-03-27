return {
	"neovim/nvim-lspconfig",
	event = "LspAttach",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"folke/neodev.nvim",
			config = function()
				require("neodev").setup({
					override = function(root_dir, library)
						if require("neodev.util").has_file(root_dir, "config/dotfiles") then
							library.enabled = true
							library.plugins = true
						end
					end
				})
			end
		}
	},
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded"
			}
		})

		require("mason-lspconfig").setup({
			automatic_installation = true
		})

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup {}
			end
		})

		local lsp_defaults = require("lspconfig").util.default_config
		lsp_defaults.capabilities = vim.tbl_deep_extend(
			"force",
			lsp_defaults.capabilities,
			require("cmp_nvim_lsp").default_capabilities()
		)

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
			{ { "n" }, "<Leader>vd",  vim.diagnostic.open_float },
			{ { "n" }, "<Leader>vws", vim.lsp.buf.workspace_symbol },
			{ { "n" }, "<Leader>vca", vim.lsp.buf.code_action },
			{ { "v" }, "<Leader>vca", vim.lsp.buf.range_code_action },
			{ { "n" }, "<Leader>rn",  vim.lsp.buf.rename },
			{ { "n" }, "gd",          vim.lsp.buf.definition },
			{ { "n" }, "gD",          vim.lsp.buf.declaration },
			{ { "n" }, "gi",          vim.lsp.buf.implementation },
			{ { "n" }, "go",          vim.lsp.buf.type_definition },
			{ { "n" }, "gr",          vim.lsp.buf.references },
			{ { "i" }, "<C-h>",       vim.lsp.buf.signature_help },
			{ { "n" }, "K",           vim.lsp.buf.hover },
			{ { "n" }, "]d",          vim.diagnostic.goto_prev },
			{ { "n" }, "[d",          vim.diagnostic.goto_next }
		})
	end
}
