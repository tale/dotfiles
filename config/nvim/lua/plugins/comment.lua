return {
	"numToStr/Comment.nvim",
	event = "BufRead",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring"
	},
	config = function()
		local ft = require("Comment.ft")
		ft.set("objc", { "//%s", "/*%s*/" })

		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end
}
