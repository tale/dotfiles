return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = true
	},
	{
		"mg979/vim-visual-multi",
		event = { "BufRead", "BufNewFile" },
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
		config = function(_, opts)
			require("nightfox").setup({ options = opts })
			vim.cmd.colorscheme("carbonfox")
		end,
	},
	{
		'echasnovski/mini.indentscope',
		version = "*",
		event = { "BufRead", "BufNewFile" },
		opts = {
			symbol = "▎",
			draw = {
				delay = 0,
				animation = function()
					return 0
				end,
			}
		}
	},
	{
		"numToStr/Comment.nvim",
		tag = "v0.8.0",
		event = "BufRead",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				commit = "6c30f3c8915d7b31c3decdfe6c7672432da1809d"
			}
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
		event = { "LspAttach", "BufRead", "BufNewFile" },
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
		tag = "v0.8.1",
		event = "BufRead",
		keys = {
			{ "<Leader>gp", "<CMD>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk" },
		},
		opts = {
			signcolumn = true,
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
		tag = "0.1.6",
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
			pickers = {
				find_files = {
					smart_cwd = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
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
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob", "!**/.git/*",
				},
				mappings = {
					i = {
						["<esc>"] = "close",
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
