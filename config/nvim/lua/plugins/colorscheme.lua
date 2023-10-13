return {
	"projekt0n/github-nvim-theme",
	lazy = false,
	priority = 1000,
	name = "github-theme",
	opts = {
		options = {
			transparent = true,
			dim_inactive = false,
			styles = {
				comments = "italic",
				keywords = "bold",
			},
			modules = {
				"cmp",
				"diagnostic",
				"gitsigns",
				"indent_blankline",
				"native_lsp",
				"telescope",
				"treesitter",
				"treesitter_context",
				"neogit",
			},
		},
	},
}
