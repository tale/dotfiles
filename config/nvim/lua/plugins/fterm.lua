return {
	"numToStr/FTerm.nvim",
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

		vim.keymap.set("n", "<D-s-g>", function()
			git:toggle()
		end)

		vim.keymap.set("t", "<D-s-g>", function()
			git:toggle()
		end)
	end
}
