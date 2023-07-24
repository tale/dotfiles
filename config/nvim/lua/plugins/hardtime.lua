return {
	"m4xshen/hardtime.nvim",
	event = "BufEnter",
	config = function()
		require("hardtime").setup({
			disabled_filetypes = {
				"oil",
				"terminal",
				"DiffviewFiles",
				"NeogitCommitMessage",
				"NeogitCommitView",
				"NeogitLog",
				"NeogitMergeMessage",
				"NeogitRebaseTodo",
				"NeogitStatus",
				""
			}
		})
	end
}
