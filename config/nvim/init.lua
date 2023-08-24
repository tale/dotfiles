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
require("lazy").setup({
	spec = {
		{ import = "plugins" }
	},
	install = {
		missing = true,
		colorscheme = { "github_dark" }
	},
	checker = {
		enabled = true,
		notify = false
	},
	change_detection = {
		enabled = true,
		notify = false
	},
	rtp = {
		disabled_plugins = {
			"netrwPlugin",
			"tohtml",
			"tutor"
		}
	},
	ui = {
		border = "rounded"
	}
})

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

-- Use the system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Automatically update buffers when files change
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.fillchars.diff = "/"
vim.opt.fillchars:append("eob: ")

-- Disable mouse support and set the font
vim.opt.mouse = nil

vim.g.bind_keys({
	-- Indentation using Tab and Shift Tab
	{ { "n" },      "<Tab>",   ">>" },
	{ { "n" },      "<S-Tab>", "<<" },
	{ { "i" },      "<Tab>",   "<C-t>" },
	{ { "i" },      "<S-Tab>", "<C-d>" },
	{ { "v" },      "<Tab>",   ">gv" },
	{ { "v" },      "<S-Tab>", "<gv" },

	-- Center the cursor on the screen so the code scrolls instead
	{ { "n", "v" }, "k",       "kzz" },
	{ { "n", "v" }, "j",       "jzz" },
	{ { "n", "v" }, "<C-d>",   "<C-d>zz" },
	{ { "n", "v" }, "<C-u>",   "<C-u>zz" },
	{ { "n" },      "n",       "nzzzv" },
	{ { "n" },      "N",       "Nzzzv" },
	{ { "n" },      "u",       "uzz" },
	{ { "n" },      "<C-r>",   "<C-r>zz" }
})

-- Hack for invoking Neogit via the command line
vim.api.nvim_create_user_command("NeogitThenQuit", function()
	require("neogit").open()

	local function watch_quit()
		if vim.bo.filetype:match("^Neogit") or vim.bo.filetype:match("^Diffview") then
			vim.defer_fn(watch_quit, 100)
		else
			vim.cmd("qa!")
		end
	end

	vim.defer_fn(watch_quit, 100)
end, {})

-- Paired Programming "Mode"
vim.api.nvim_create_user_command("Pair", function()
	os.execute("zed " .. vim.fn.getcwd())
end, {})
