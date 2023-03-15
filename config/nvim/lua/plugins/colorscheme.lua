return {
 	"sainnhe/sonokai",
 	lazy = false,
 	config = function()
 		vim.opt.termguicolors = true
		vim.g.sonokai_style = "andromeda"
 		vim.cmd.colorscheme("sonokai")
 	end
}

