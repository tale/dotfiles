return {
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.1",
		cmd = "TSUpdate",
		event = "BufRead",
		build = ":TSUpdate",
		opts = {
			ts = {
				ensure_installed = {
					"bash", "c", "cpp", "css", "dockerfile", "git_config",
					"git_rebase", "gitattributes", "gitcommit", "gitignore",
					"go", "html", "java", "javascript", "json", "lua", "markdown",
					"objc", "python", "regex", "rust", "sql", "toml", "tsx",
					"typescript", "vim", "vimdoc", "xml", "yaml", "zig"
				},
				sync_install = vim.fn.filereadable("/.dockerenv"),
				auto_install = not vim.fn.filereadable("/.dockerenv"),
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
		cmd = "Neogit",
		opts = {
			disable_hint = true,
			kind = "replace"
		},
		config = function(_, options)
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
		end,
	},
}
