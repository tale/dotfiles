return {
	"projekt0n/github-nvim-theme",
	lazy = false,
	priority = 1000,
	config = function()
		require("github-theme").setup({
			options = {
				transparent = true,
				dim_inactive = false,
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
					"telescope",
					"treesitter",
					"treesitter_context",
					"neogit"
				}
			}
		})

		vim.cmd.colorscheme("github_dark_tritanopia")
		vim.api.nvim_set_option("background", "dark")
	end
}
