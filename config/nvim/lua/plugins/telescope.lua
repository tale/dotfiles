return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	event = "VimEnter",
	keys = {
		"<Leader>gt",
		"<Leader>ff",
		"<Leader>fi",
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
		local builtin = require("telescope.builtin")

		vim.g.bind_keys({
			{ { "n", "t" }, "<Leader>gt", builtin.find_files },
			{ { "n", "t" }, "<Leader>ff", builtin.find_files },
			{ { "n", "t" }, "<Leader>fi", builtin.live_grep },
			{ { "n" }, "gr", builtin.lsp_references },
			{ { "n" }, "gi", builtin.lsp_implementations },
			{ { "n" }, "gd", builtin.lsp_definitions },
		})
	end,
}
