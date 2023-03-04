return {
	"eandrju/cellular-automaton.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter"
	},
	config = function()
		vim.g.bind_keys({
			{ { "n", "v" }, "<D-m>", "<CMD>CellularAutomaton make_it_rain<CR>" },
		})
	end
}
