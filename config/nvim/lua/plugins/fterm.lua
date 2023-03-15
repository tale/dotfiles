return {
	"numToStr/FTerm.nvim",
	keys = {
		"<C-`>",
		"<D-S-g>"
	},
	config = function()
		require("FTerm").setup({
			border = "rounded",
			ft = "terminal",
			-- Pin to the bottom of the window
			dimensions = {
				x = 0.0,
				y = 1.0,
				height = 0.4,
				width = 1.0
			},
		})

		vim.g.bind_keys({
			{ { "n", "x" }, "<C-`>", require("FTerm").toggle },
			{ { "t" },      "<C-`>", "<C-\\><C-n><CMD>lua require(\"FTerm\").toggle()<CR>" }
		})


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
			{ { "n", "v", "t" }, "<D-S-g>", function()
				require("neo-tree.sources.manager").refresh("filesystem")
				git:toggle()
			end },
		})
	end
}
