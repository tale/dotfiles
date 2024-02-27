return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		build = ":TSUpdate",
		opts = {
			ts = {
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
				},
				autotag = {
					enable = true,
				}
			},
			comment = {
				enable_autocmd = false,
			}
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts.ts)
			require("ts_context_commentstring").setup(opts.comment)
		end,
	},
	{
		"aserowy/tmux.nvim",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<A-h>", "<A-j>", "<A-k>", "<A-l>" },
		opts = {
			copy_sync = {
				enable = false,
			},
			navigation = {
				cycle_navigation = false,
				enable_default_keybindings = true,
			},
			resize = {
				resize_step_x = 5,
				resize_step_y = 5,
				enable_default_keybindings = true,
			},
		},
	},
	{
		"NeogitOrg/neogit",
		cmd = "NeogitThenQuit",
		opts = {
			disable_hint = true,
			disable_context_highlighting = false,
			kind = "replace",
			signs = {
				hunk = { "", "" },
				item = { "", "" },
				section = { "", "" },
			},
		},
		config = function(_, options)
			-- Hack for invoking Neogit via the command line with the tmux popup
			vim.api.nvim_create_user_command("NeogitThenQuit", function()
				require("neogit").setup(options)
				require("neogit").open()

				local function watch_quit()
					if vim.bo.filetype:match("^Neogit") then
						vim.defer_fn(watch_quit, 100)
					else
						vim.cmd("silent! qa!")
					end
				end

				vim.defer_fn(watch_quit, 100)
			end, {})
		end,
	},
}
