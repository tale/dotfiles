return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.1",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make"
		}
	},
	config = function()
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

		require("telescope").load_extension("fzf")
		local builtin = require("telescope.builtin")

		-- Command + P opens the file finder
		vim.keymap.set("n", "<D-p>", builtin.find_files, {})

		-- Command + Shift + F opens the live grep
		vim.keymap.set("n", "<D-s-f>", builtin.live_grep, {})
	end
}
