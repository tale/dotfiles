return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"folke/neoconf.nvim",
			config = function()
				require("neoconf").setup({})
			end
		},
		{
			"folke/neodev.nvim",
			config = function()
				require("neodev").setup({
					override = function(root_dir, library)
						if require("neodev.util").has_file(root_dir, "~/.config/dotfiles") then
							library.enabled = true
							library.plugins = true
						end
					end
				})
			end
		}
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
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

				if client then
					vim.cmd("silent! EslintFixAll")
				else
					vim.lsp.buf.format({ async = true })
				end
			end,
			pattern = { "*" }
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function()
				local bufmap = function(mode, lhs, rhs)
					local opts = { buffer = true }
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				vim.keymap.set("n", "<D-.>", vim.diagnostic.open_float, { noremap = true, silent = true })
				vim.keymap.set("n", "<S-D-s>", vim.lsp.buf.code_action, { noremap = true, silent = true })

				bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
				bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
				bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
				bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
				bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
				bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
				bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
				bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
				bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
				bufmap("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")
				bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
				bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
			end
		})
	end
}
