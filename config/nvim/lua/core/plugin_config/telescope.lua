local builtin = require('telescope.builtin')

vim.keymap.set('n', '<D-p>', builtin.find_files, {})
vim.keymap.set('n', '<D-s-f>', builtin.live_grep, {})
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})

