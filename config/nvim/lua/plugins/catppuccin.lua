return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		vim.opt.termguicolors = true
		require("catppuccin").setup({
			flavour = "macchiato",
			background = {
				dark = "macchiato"
			}
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
