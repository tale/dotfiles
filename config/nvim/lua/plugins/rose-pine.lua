return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	config = function()
		require("rose-pine").setup({
			variant = "auto",
			dark_variant = "moon",
			bold_vert_split = true
		})

		vim.opt.termguicolors = true
		vim.cmd.colorscheme("rose-pine")
	end
}
