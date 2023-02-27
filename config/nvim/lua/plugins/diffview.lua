return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim"
	},
	config = function()
		require("diffview").setup()
		vim.keymap.set("n", "<D-d>", function()
			local view = require("diffview.lib").get_current_view()

			if view then
				vim.cmd("DiffviewClose")
			else
				vim.cmd("DiffviewOpen")
			end
		end, { noremap = true, silent = true })
	end
}
