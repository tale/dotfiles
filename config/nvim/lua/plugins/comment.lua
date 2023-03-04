return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()

		vim.g.bind_keys({
			{ { "n", "v" }, "<D-/>", require("Comment.api").toggle.linewise.current },
		})
	end
}
