vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- QoL Settings
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- Proper Tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- Clear the search because the highlighting hurts
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

