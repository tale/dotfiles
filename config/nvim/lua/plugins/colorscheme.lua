return {
	"marko-cerovac/material.nvim",
	lazy = false,
	config = function()
		require("material").setup({
			lualine_style = "stealth",
			contrast = {
				cursor_line = true,
			},
		})

		vim.opt.termguicolors = true
		vim.g.material_style = "palenight"
		vim.cmd.colorscheme("material")
	end
}
