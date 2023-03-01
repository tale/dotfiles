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
				}
			},
			find_files = {
				hidden = true,
				smart_cwd = true
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

		-- Command + P opens the file finder
		vim.keymap.set("n", "<D-p>", builtin.find_files, { silent = true })

		-- Command + Shift + F opens the live grep
		vim.keymap.set("n", "<D-S-F>", builtin.live_grep, { silent = true })

		-- Command + Shift + P opens the command center
		vim.keymap.set("n", "<D-S-P>", ":Telescope command_center<CR>", { silent = true })
	end
}
