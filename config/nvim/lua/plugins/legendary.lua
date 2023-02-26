return {
	"mrjones2014/legendary.nvim",
	dependencies = {
		"stevearc/dressing.nvim",
		"kkharji/sqlite.lua"
	},
	config = function()
		vim.keymap.set("n", "<S-D-p>", ":Legendary<CR>", { noremap = true })
	end
}
