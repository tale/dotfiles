return {
	"Shatur/neovim-ayu",
	lazy = false,
	config = function()
		require("ayu").setup({
			mirage = true
		})

		vim.opt.termguicolors = true
		vim.o.background = "dark"
		vim.cmd.colorscheme("ayu")
	end
}
