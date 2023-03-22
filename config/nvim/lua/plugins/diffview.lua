return {
	"sindrets/diffview.nvim",
	keys = {
		"<Leader>df"
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim"
	},
	config = function()
		require("diffview").setup()
		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>df", function()
				local view = require("diffview.lib").get_current_view()

				if view then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end },
		})
	end
}
