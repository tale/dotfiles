return {
	"eandrju/cellular-automaton.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter"
	},
	config = function()
		vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { noremap = true, silent = true })
	end
}
