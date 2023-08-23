return {
	"ggandor/leap.nvim",
	event = "BufRead",
	config = function()
		require("leap").add_default_mappings()
		require("leap").opts.highlight_unlabeled_phase_one_targets = true

		vim.api.nvim_create_autocmd(
			"User",
			{
				callback = function()
					vim.cmd.hi("Cursor", "blend=100")
					vim.opt.guicursor:append { "a:Cursor/lCursor" }
				end,
				pattern = "LeapEnter"
			}
		)
		vim.api.nvim_create_autocmd(
			"User",
			{
				callback = function()
					vim.cmd.hi("Cursor", "blend=0")
					vim.opt.guicursor:remove { "a:Cursor/lCursor" }
				end,
				pattern = "LeapLeave"
			}
		)
	end
}
