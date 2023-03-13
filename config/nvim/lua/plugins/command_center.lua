return {
	"FeiyouG/command_center.nvim",
	keys = {
		"<D-p>"
	},
	dependencies = {
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		require("command_center").add({
			{
				desc = "File: Format Document",
				cmd = function()
					vim.lsp.buf.format({ async = true })
				end
			},
			{
				desc = "File: Disable Formatting",
				cmd = function()
					vim.opt.eventignore = { "BufWritePre" }
				end
			},
			{
				desc = "File: Enable Formatting",
				cmd = function()
					vim.opt.eventignore = {}
				end
			},
			{
				desc = "File: Save without formatting",
				cmd = function()
					vim.opt.eventignore = { "BufWritePre" }
					vim.cmd("silent! write")
					vim.opt.eventignore = {}
				end
			},
			{
				desc = "ESLint: Fix all auto-fixable problems",
				cmd = function()
					vim.cmd("silent! EslintFixAll")
				end
			},
			{
				desc = "YAML: Select Schema",
				cmd = function()
					vim.cmd("silent! Telescope yaml_schema")
				end
			},
			{
				desc = "Language: Restart LSP Server",
				cmd = function()
					vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
					vim.cmd("silent! edit")
				end
			},
			{
				desc = "ESLint: Restart ESLint Server",
				cmd = function()
					local client = vim.lsp.get_active_clients({
						name = "eslint"
					})

					if client then
						vim.lsp.stop_client(client.id, true)
						vim.cmd("silent! edit")
					end
				end
			},
			{
				desc = "Settings: Manage Language Servers",
				cmd = "<CMD>Mason<CR>"
			},
			{
				desc = "Settings: Manage Plugins",
				cmd = "<CMD>Lazy<CR>"
			},
			{
				desc = "Settings: Ragequit",
				cmd = "<cmd>CellularAutomaton make_it_rain<CR>"
			}
		})
	end
}
