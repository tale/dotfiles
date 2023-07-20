return {
	"NeogitOrg/neogit",
	keys = {
		"<Leader>df"
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"sindrets/diffview.nvim",
		"nvim-lua/plenary.nvim"
	},
	config = function()
		require("diffview").setup()
		require("neogit").setup({
			integrations = {
				diffview = true
			}
		})
		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>df", function()
				require("neogit").open()
			end },
		})
	end
}
