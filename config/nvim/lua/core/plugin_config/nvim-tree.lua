vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
	filters = {
		custom = {
			'.DS_Store',
			'.git/'
		}
	}
})

-- Control-N opens the directory of the current file
vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<D-s-e>', ':NvimTreeFocus<CR>')
