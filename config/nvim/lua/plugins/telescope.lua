return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.1",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"FeiyouG/command_center.nvim",
		"stevearc/dressing.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make"
		}
	},
	config = function()
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("command_center")

		require("command_center").add({
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
			}
		})

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close
					}
				}
			},
			find_files = {
				hidden = true,
				smart_cwd = true
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = false,
					override_file_sorter = true,
					case_mode = "smart_case"
				}
			}
		})

		local builtin = require("telescope.builtin")

		-- Command + P opens the file finder
		vim.keymap.set("n", "<D-p>", builtin.find_files, { silent = true })

		-- Command + Shift + F opens the live grep
		vim.keymap.set("n", "<D-s-f>", builtin.live_grep, { silent = true })

		-- Command + Shift + P opens the command center
		vim.keymap.set("n", "<D-s-p>", ":Telescope command_center<CR>", { silent = true })
	end
}
