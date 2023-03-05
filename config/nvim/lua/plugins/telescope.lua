return {
	"nvim-telescope/telescope.nvim",
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
				}
			}
		})

		local builtin = require("telescope.builtin")

		vim.g.bind_keys({
			{ { "n", "i", "t" }, "<D-p>",   builtin.find_files },
			{ { "n", "i", "t" }, "<D-S-F>", builtin.live_grep },
			{ { "n", "i", "t" }, "<D-S-P>", ":Telescope command_center<CR>" },
		})
	end
}
