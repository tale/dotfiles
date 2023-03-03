return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-`>]],
			shade_terminals = true,
			shell = "zsh"
		})
	end
}
