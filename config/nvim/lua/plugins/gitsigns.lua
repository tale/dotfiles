return {
	"lewis6991/gitsigns.nvim",
	config = function()
		vim.opt.signcolumn = "yes"

		require("gitsigns").setup({
			signcolumn = true,
			numhl = true,
		})
	end
}
