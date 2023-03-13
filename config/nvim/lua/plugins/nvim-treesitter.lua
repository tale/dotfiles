return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufRead",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local update = require("nvim-treesitter.install").update({ with_sync = true })
		update()

		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end
}
