return {
	"lewis6991/gitsigns.nvim",
	event = "BufRead",
	config = function()
		vim.opt.signcolumn = "yes"

		require("gitsigns").setup({
			signcolumn = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 250
			},
		})
	end
}
