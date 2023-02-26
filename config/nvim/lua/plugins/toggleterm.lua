return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-`>]],
			shade_terminals = false,
			shell = "zsh"
		})
	end
}
