return {
	"nvim-telescope/telescope.nvim",
	keys = {
		"<D-p>",
		"<D-S-f>",
		"<D-S-p>"
	},
	tag = "0.1.1",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"FeiyouG/command_center.nvim",
		"stevearc/dressing.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make"
		}
	},
	config = function()
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("command_center")
		local command_center = require("command_center")

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close
					}
				},
				file_ignore_patterns = {
					".git/",
					"node_modules/",
					"%.class"
				}
			},
			pickers = {
				find_files = {
					hidden = true,
					smart_cwd = true
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = false,
					override_file_sorter = true,
					case_mode = "smart_case"
				},
				command_center = {
					components = {
						command_center.component.DESC,
						command_center.component.KEYS,
					},
					sort_by = {
						command_center.component.DESC,
						command_center.component.KEYS,
					},
					auto_replace_desc_with_cmd = false,
				}
			}
		})

		local builtin = require("telescope.builtin")

		vim.g.bind_keys({
			{ { "n", "i", "t" }, "<D-p>",      builtin.find_files },
			{ { "n", "i", "t" }, "<D-S-f>",    builtin.live_grep },
			{ { "n", "i", "v" }, "<Leader>vo", builtin.diagnostics },
			{ { "n", "i", "t" }, "<D-S-p>",    ":Telescope command_center<CR>" },
		})
	end
}
