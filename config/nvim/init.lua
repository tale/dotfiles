require("tale.opts")
require("tale.keys")

-- Clone lazy.nvim if it doesn't exist before harness
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
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{ "nvim-lua/plenary.nvim",       lazy = true }
	},
	install = { colorscheme = { "lunaperche" } },
	change_detection = { notify = false },
	rtp = {
		disabled_plugins = {
			"netrwPlugin",
			"tohtml",
			"tutor",
		}
	},
})
