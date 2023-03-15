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

-- Create a global function to easily bind keys
vim.g.bind_keys = function(bindings)
	for _, binding in ipairs(bindings) do
		local opts = { noremap = true, silent = true }
		vim.keymap.set(binding[1], binding[2], binding[3], opts)
	end
end

-- Plugins use the bind_keys() function and mapleader
vim.g.mapleader = " "
require("lazy").setup("plugins")

-- Set tab size to 4 and show cursor line highlight
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.cursorline = true

-- Relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Split buffers onto the second child (right and bottom)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Automatically update buffers when files change
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.fillchars.diff = "/"
vim.opt.fillchars:append("eob: ")
vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"

vim.g.bind_keys({
	-- Move between splits and buffers
	-- "Hide Neovim" needs to be rebinded via Preferences
	{ { "n", "i", "t" }, "<D-h>",   "<C-\\><C-N><C-w>h" },
	{ { "n", "i", "t" }, "<D-j>",   "<C-\\><C-N><C-w>j" },
	{ { "n", "i", "t" }, "<D-k>",   "<C-\\><C-N><C-w>k" },
	{ { "n", "i", "t" }, "<D-l>",   "<C-\\><C-N><C-w>l" },

	-- Indentation using Tab and Shift Tab
	{ { "n" },           "<Tab>",   ">>" },
	{ { "n" },           "<S-Tab>", "<<" },
	{ { "i" },           "<Tab>",   "<C-t>" },
	{ { "i" },           "<S-Tab>", "<C-d>" },
	{ { "v" },           "<Tab>",   ">gv" },
	{ { "v" },           "<S-Tab>", "<gv" },

	-- Cut, copy, paste bindings in all modes
	{ { "n", "v" },      "<D-x>",   "\"+x" },
	{ { "n", "v" },      "<D-c>",   "\"+y" },
	{ { "n", "v" },      "<D-v>",   "\"+P" },
	{ { "c" },           "<D-v>",   "<C-R>+" },
	{ { "t" },           "<D-v>",   "<C-\\><C-N>\"+p<CR>i" },
	{ { "i" },           "<D-v>",   "<CMD>set paste<CR><C-R>+<CMD>set nopaste<CR>" },

	-- Center on the screen so the code scrolls instead
	{ { "n" },           "<C-d>",   "<C-d>zz" },
	{ { "n" },           "<C-u>",   "<C-u>zz" },
	{ { "n" },           "n",       "nzzzv" },
	{ { "n" },           "N",       "Nzzzv" }
})

