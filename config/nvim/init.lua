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

vim.g.mapleader = " " -- Lazy needs this beforehand
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { missing = true },
	ui = { border = "rounded" },
	change_detection = {
		enabled = true,
		notify = false,
	},
	rtp = { disabled_plugins = {
		"netrwPlugin",
		"tohtml",
		"tutor",
	} },
})

vim.cmd.colorscheme("github_dark_tritanopia")
vim.api.nvim_set_option("background", "dark")

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Set tab size to 4 and show cursor line highlight
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.cursorline = true

-- Relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Split buffers onto the second child (right and bottom)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Use the system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Automatically update buffers when files change
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.fillchars.diff = "/"
vim.opt.fillchars:append("eob: ")
vim.opt.mouse = nil

local function bind_keys(bindings)
	for _, binding in ipairs(bindings) do
		local opts = { noremap = true, silent = true }
		vim.keymap.set(binding[1], binding[2], binding[3], opts)
	end
end

bind_keys({
	-- Indentation using Tab and Shift Tab
	{ { "n" }, "<Tab>", ">>" },
	{ { "n" }, "<S-Tab>", "<<" },
	{ { "i" }, "<Tab>", "<C-t>" },
	{ { "i" }, "<S-Tab>", "<C-d>" },
	{ { "v" }, "<Tab>", ">gv" },
	{ { "v" }, "<S-Tab>", "<gv" },

	-- Center the cursor on the screen so the code scrolls instead
	{ { "n", "v" }, "k", "kzz" },
	{ { "n", "v" }, "j", "jzz" },
	{ { "n", "v" }, "<C-d>", "<C-d>zz" },
	{ { "n", "v" }, "<C-u>", "<C-u>zz" },
	{ { "n" }, "n", "nzzzv" },
	{ { "n" }, "N", "Nzzzv" },
	{ { "n" }, "u", "uzz" },
	{ { "n" }, "<C-r>", "<C-r>zz" },
})

-- Paired Programming "Mode"
vim.api.nvim_create_user_command("Pair", function()
	os.execute("zed " .. vim.fn.getcwd())
end, {})
