return {
	"ThePrimeagen/harpoon",
	event = "BufRead",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		require("harpoon").setup({
			excluded_filetypes = {
				"harpoon",
				"TelescopePrompt",
				"TelescopeResults",
				"TelescopePreview",
				"neo-tree",
				"terminal"
			}
		})

		require("telescope").load_extension("harpoon")

		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>hc", require("harpoon.mark").add_file },
			{ { "n", "v" }, "<Leader>hn", require("harpoon.ui").nav_next },
			{ { "n", "v" }, "<Leader>hp", require("harpoon.ui").nav_prev },
			{ { "n", "v" }, "<Leader>hh", require("telescope").extensions.harpoon.marks },
		})
	end
}
