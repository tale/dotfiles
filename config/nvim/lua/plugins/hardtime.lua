return {
	"m4xshen/hardtime.nvim",
	event = "BufEnter",
	config = function()
		require("hardtime").setup({
			disabled_filetypes = {
				"oil",
				"terminal",
				"DiffviewFiles",
				"NeogitStatus",
				"NeogitCommitMessage",
				"NeogitPopup",
				""
			}
		})
	end
}
