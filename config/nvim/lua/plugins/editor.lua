return {
	{
		"wakatime/vim-wakatime",
		event = "BufRead",
	},
	{
		"mg979/vim-visual-multi",
		event = "BufRead",
	},
	{
		"nmac427/guess-indent.nvim",
		event = "BufRead",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		name = "ibl",
		opts = {
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local ft = require("Comment.ft")
			local ts = require("ts_context_commentstring.integrations.comment_nvim")

			ft.set("objc", { "//%s", "/*%s*/" })
			require("Comment").setup({
				pre_hook = ts.create_pre_hook(),
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		opts = {
			signcolumn = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 250,
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		event = "VimEnter",
		keys = {
			{ "<Leader>gt", "<CMD>Telescope find_files hidden=true<CR>", desc = "Find files" },
			{ "<Leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find files" },
			{ "<Leader>fi", "<CMD>Telescope live_grep<CR>", desc = "Search within files" },
			{ "<Leader>gr", "<CMD>Telescope lsp_references<CR>", desc = "Find references" },
			{ "<Leader>gi", "<CMD>Telescope lsp_implementations<CR>", desc = "Find implementations" },
			{ "<Leader>gd", "<CMD>Telescope lsp_definitions<CR>", desc = "Find definitions" },
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<esc>"] = "close",
					},
				},
				file_ignore_patterns = {
					".git/",
					"node_modules/",
					"%.class",
				},
				pickers = {
					find_files = {
						hidden = true,
						smart_cwd = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			},
		},
		config = function(_, options)
			require("telescope").setup(options)
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"stevearc/oil.nvim",
		event = "VimEnter",
		keys = {
			{
				"<C-e>",
				function()
					if vim.bo.filetype == "oil" then
						require("oil").close()
					else
						require("oil").open()
					end
				end,
				desc = "Toggle Oil file browser",
				mode = { "n", "i", "t", "v", "x" },
			},
		},
		opts = {
			delete_to_trash = true,
			trash_command = "trash",
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<C-x>"] = "actions.select_split",
				["<C-v>"] = "actions.select_vsplit",
			},
		},
	},
}
