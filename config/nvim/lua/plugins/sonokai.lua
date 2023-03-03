return {
	"sainnhe/sonokai",
	config = function()
		vim.opt.termguicolors = true
		vim.g.sonokai_style = "shusia"
		vim.cmd.colorscheme("sonokai")
	end
}
