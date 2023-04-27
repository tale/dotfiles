return {
	"aserowy/tmux.nvim",
	lazy = false,
	config = function()
		require("tmux").setup({
			copy_sync = {
				enable = false,
			},
			navigation = {
				cycle_navigation = false,
			},
			resize = {
				resize_step_x = 5,
				resize_step_y = 5,
			}
		})

		vim.g.bind_keys({
			-- Move between splits and buffers between Tmux
			{ { "n", "i", "t" }, "<C-h>", require("tmux").move_left },
			{ { "n", "i", "t" }, "<C-j>", require("tmux").move_bottom },
			{ { "n", "i", "t" }, "<C-k>", require("tmux").move_top },
			{ { "n", "i", "t" }, "<C-l>", require("tmux").move_right },

			-- Easily resize splits and buffers between Tmux
			{ { "n", "i", "t" }, "<M-h>", require("tmux").resize_left },
			{ { "n", "i", "t" }, "<M-j>", require("tmux").resize_bottom },
			{ { "n", "i", "t" }, "<M-k>", require("tmux").resize_top },
			{ { "n", "i", "t" }, "<M-l>", require("tmux").resize_right },
		})
	end,
}
