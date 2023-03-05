return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		local update = require("nvim-treesitter.install").update({ with_sync = true })
		update()

		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
		})
	end
}
