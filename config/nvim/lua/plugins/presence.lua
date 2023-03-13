return {
	"andweeb/presence.nvim",
	config = function()
		require("presence").setup({
			neovim_image_text = "Neovim"
		})
	end
}
