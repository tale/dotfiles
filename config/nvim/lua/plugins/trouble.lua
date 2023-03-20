return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	event = "LspAttach",
	config = function()
		require("trouble").setup()
		vim.g.bind_keys({
			{ { "n", "v", "t" }, "<Leader>vo", require("trouble").open },
		})
	end
}
