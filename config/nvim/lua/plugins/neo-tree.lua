return {
	"nvim-neo-tree/neo-tree.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			config = function()
				require("window-picker").setup({
					autoselect_one = true,
					include_current_win = false,
					other_win_hl_color = "#2e3238"
				})
			end
		}
	},
	config = function()
		-- Disable v1 commands from neo-tree
		vim.g.neo_tree_remove_legacy_commands = 1

		vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			window = {
				position = "right",
				width = 30,
				mapping_options = {
					noremap = true,
					nowait = true
				},
				mappings = {
					["<CR>"] = "open_or_window",
					["<C-x>"] = "open_split",
					["<C-v>"] = "open_vsplit"
				}
			},
			filesystem = {
				use_libuv_file_watcher = true,
				follow_current_file = true,
				filtered_items = {
					hide_dotfiles = false,
					visible = true,
					never_show = {
						".git",
						".DS_Store"
					},
					never_show_by_pattern = {
						"*.class"
					}
				},
				commands = {
					open_or_window = function(state)
						local wrap = require("neo-tree.utils").wrap
						local commands = require("neo-tree.sources.common.commands")
						local toggle_directory = require("neo-tree.sources.filesystem").toggle_directory

						if vim.fn.winnr("$") == 1 and vim.bo.filetype == "neo-tree" then
							commands.open(state, wrap(toggle_directory, state))
						else
							commands.open_with_window_picker(state, wrap(toggle_directory, state))
						end
					end
				}
			},
			default_component_configs = {
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					default = ""
				},
				git_status = {
					symbols = {
						added = "",
						modified = "",
						deleted = "",
						renamed = "➜",
						untracked = "",
						ignored = "◌",
						unstaged = "",
						staged = "✓",
						confligt = ""
					}
				}
			}
		})

		vim.g.bind_keys({
			{ { "n", "i", "t", "v", "x" }, "<C-e>", "<CMD>Neotree<CR>" }
		})
	end
}
