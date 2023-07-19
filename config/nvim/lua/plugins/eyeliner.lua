return {
	"jinh0/eyeliner.nvim",
	event = "BufRead",
	config = function()
		require("eyeliner").setup({
			highlight_on_key = true,
			dim = true
		})
	end
}
