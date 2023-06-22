return {
	"projekt0n/github-nvim-theme",
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

		vim.cmd.colorscheme("github_dark_tritanopia")
	end
}
