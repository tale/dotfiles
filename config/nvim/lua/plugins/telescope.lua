return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	keys = {
		"<Leader>gt",
		"<Leader>ff",
		"<Leader>fi",
		"<Leader>cc"
	},
	tag = "0.1.1",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make"
		}
	},
	config = function()
		require("telescope").load_extension("fzf")

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
			{ { "n", "t" }, "<Leader>gt", builtin.find_files },
			{ { "n", "t" }, "<Leader>ff", builtin.find_files },
			{ { "n", "t" }, "<Leader>fi", builtin.live_grep },
			{ { "n" },      "gr",         builtin.lsp_references },
			{ { "n" },      "gi",         builtin.lsp_implementations },
			{ { "n" },      "gd",         builtin.lsp_definitions }
		})
	end
}
