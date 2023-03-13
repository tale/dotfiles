return {
	"zbirenbaum/copilot.lua",
	event = "BufEnter",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 250,
				keymap = {
					accept = "<M-CR>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>"
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			}
		})
	end
}
