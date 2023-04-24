return {
	"ThePrimeagen/harpoon",
	event = "BufRead",
	dependencies = {
		"nvim-lua/plenary.nvim",
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

		local function harpoon_specific(file)
			return function()
				require("harpoon.ui").nav_file(file)
			end
		end

		vim.g.bind_keys({
			{ { "n", "v" }, "<Leader>hc", require("harpoon.mark").add_file },
			{ { "n", "v" }, "<Leader>hn", require("harpoon.ui").nav_next },
			{ { "n", "v" }, "<Leader>hp", require("harpoon.ui").nav_prev },
			{ { "n", "v" }, "<Leader>hh", require("harpoon.ui").toggle_quick_menu },
			{ { "n", "v" }, "<Leader>h1", harpoon_specific(1) },
			{ { "n", "v" }, "<Leader>h2", harpoon_specific(2) },
			{ { "n", "v" }, "<Leader>h3", harpoon_specific(3) },
			{ { "n", "v" }, "<Leader>h4", harpoon_specific(4) },
			{ { "n", "v" }, "<Leader>h5", harpoon_specific(5) },
			{ { "n", "v" }, "<Leader>h6", harpoon_specific(6) },
			{ { "n", "v" }, "<Leader>h7", harpoon_specific(7) },
			{ { "n", "v" }, "<Leader>h8", harpoon_specific(8) },
			{ { "n", "v" }, "<Leader>h9", harpoon_specific(9) },
		})
	end
}
