return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()

		vim.keymap.set("n", "<D-/>", require("Comment.api").toggle.linewise.current, { noremap = true, silent = true })
		vim.keymap.set("v", "<D-/>", require("Comment.api").toggle.linewise.current, { noremap = true, silent = true })
	end
}
