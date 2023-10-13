return {
	{
		"wakatime/vim-wakatime",
		event = "BufRead",
	},
	{
		"mg979/vim-visual-multi",
		event = "BufRead",
	},
	{
		"nmac427/guess-indent.nvim",
		event = "BufRead",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		name = "ibl",
		opts = {
			indent = {
				char = "▏",
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local ft = require("Comment.ft")
			local ts = require("ts_context_commentstring.integrations.comment_nvim")

			ft.set("objc", { "//%s", "/*%s*/" })
			require("Comment").setup({
				pre_hook = ts.create_pre_hook(),
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		opts = {
			signcolumn = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 250,
			},
		},
	},
}
