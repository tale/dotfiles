return {
	"Shatur/neovim-ayu",
	lazy = false,
	config = function()
		require("ayu").setup({
			mirage = true
		})

		vim.opt.termguicolors = true
		vim.o.background = "dark"
		require("ayu").colorscheme()
	end
}
