return {
	"projekt0n/github-nvim-theme",
	dependencies = {
		"f-person/auto-dark-mode.nvim"
	},
	lazy = false,
	priority = 1000,
	config = function()
		require("github-theme").setup({
			options = {
				styles = {
					comments = "italic",
					keywords = "bold"
				},
				modules = {
					"cmp",
					"diagnostic",
					"fzf",
					"gitsigns",
					"indent_blankline",
					"native_lsp",
					"neotree",
					"telescope",
					"treesitter",
					"treesitter_context"
				}
			}
		})

		require("auto-dark-mode").setup({
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd.colorscheme("github_dark_tritanopia")
				vim.api.nvim_set_option("background", "dark")
			end,
			set_light_mode = function()
				vim.cmd.colorscheme("github_light")
				vim.api.nvim_set_option("background", "light")
			end
		})
	end
}
