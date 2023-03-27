return {
	"eandrju/cellular-automaton.nvim",
	event = "BufRead",
	dependencies = {
		"nvim-treesitter/nvim-treesitter"
	},
	config = function()
		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>woe", "<CMD>CellularAutomaton make_it_rain<CR>" },
		})
	end
}
