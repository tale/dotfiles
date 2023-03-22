return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufRead",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter-context"
	},
	config = function()
		local update = require("nvim-treesitter.install").update({ with_sync = true })
		update()

		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false
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
