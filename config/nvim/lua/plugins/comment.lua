return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring"
	},
	event = "BufEnter",
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})

		vim.g.bind_keys({
			{ { "n" }, "<D-/>", require("Comment.api").toggle.linewise.current },
			{ { "v" }, "<D-/>", function()
				local esc = vim.api.nvim_replace_termcodes(
					'<ESC>', true, false, true
				)

				vim.api.nvim_feedkeys(esc, 'nx', false)
				require("Comment.api").toggle.linewise(vim.fn.visualmode())
			end }
		})
	end
}
