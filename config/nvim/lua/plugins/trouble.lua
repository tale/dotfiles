return {
	"folke/trouble.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		require("trouble").setup({})

		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>xw", "<CMD>TroubleToggle workspace_diagnostics<CR>" },
			{ { "n", "v" }, "<Leader>xq", "<CMD>TroubleToggle quickfix<CR>" }
		})
	end
}
