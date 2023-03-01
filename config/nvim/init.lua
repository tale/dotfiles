-- Bootstrap lazy.nvim to ensure it is always installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- Set tab size to 4 and show cursor line highlight
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.cursorline = true

-- Automatically update buffers when files change
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.fillchars.diff = "/"

-- Move between splits using Command keys
-- "Hide Neovim" was disabled via System Settings
vim.keymap.set("n", "<D-h>", "<c-w>h")
vim.keymap.set("n", "<D-j>", "<c-w>j")
vim.keymap.set("n", "<D-k>", "<c-w>k")
vim.keymap.set("n", "<D-l>", "<c-w>l")

vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"

-- Configure cut/copy/paste commands using Command key on macOS
vim.keymap.set("v", "<D-x>", "\"+x")
vim.keymap.set("v", "<D-c>", "\"+y")
vim.keymap.set("n", "<D-v>", "\"+P")
vim.keymap.set("v", "<D-v>", "\"+P")
vim.keymap.set("c", "<D-v>", "<C-R>+")
vim.keymap.set("i", "<D-v>", "<C-R>+")

-- Select all text using Command + A
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-a>", "ggVG<CR>", { noremap = true, silent = true })

-- Configure undo/redo/save/new commands using Command key on macOS
vim.api.nvim_set_keymap("n", "<D-n>", ":enew<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-z>", ":u<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-y>", ":redo<CR>", { noremap = true, silent = true })
