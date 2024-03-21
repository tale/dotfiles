return {
	"wakatime/vim-wakatime",
	"mg979/vim-visual-multi",
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		name = "ibl",
		opts = {}
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
		"zbirenbaum/copilot.lua",
		opts = {
			panel = { enabled = false },
			suggestion = {
				auto_trigger = true,
				keymap = { accept = "<M-CR>" },
			},
			filetypes = { yaml = true, markdown = true },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		keys = {
			{ "<Leader>gp", "<CMD>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk" },
		},
		opts = {
			signcolumn = true,
			current_line_blame = true,
			current_line_blame_opts = { delay = 250 },
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			}
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
		keys = {
			{ "<C-p>", "<CMD>Telescope find_files<CR>",      desc = "Find files" },
			{ "<C-[>", "<CMD>Telescope live_grep<CR>",       desc = "Find text" },
			{ "gr",    "<CMD>Telescope lsp_references<CR>",  desc = "Find references" },
			{ "gd",    "<CMD>Telescope lsp_definitions<CR>", desc = "Find definitions" },
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<esc>"] = "close",
					},
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
