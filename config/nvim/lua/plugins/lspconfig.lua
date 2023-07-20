return {
	"neovim/nvim-lspconfig",
	event = "VimEnter",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"pmizio/typescript-tools.nvim",
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

		require("typescript-tools").setup()

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
	end
}
