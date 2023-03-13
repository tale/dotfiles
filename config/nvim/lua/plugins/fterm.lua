return {
	"numToStr/FTerm.nvim",
	keys = {
		"<D-S-G>"
	},
	config = function()
		local fterm = require("FTerm")
		local git = fterm:new({
			ft = "lazygit",
			cmd = "lazygit",
			border = "rounded",
			dimensions = {
				height = 0.9,
				width = 0.9
			}
		})

		vim.g.bind_keys({
			{ { "n", "v", "t" }, "<D-S-G>", function()
				git:toggle()
			end },
		})
	end
}
