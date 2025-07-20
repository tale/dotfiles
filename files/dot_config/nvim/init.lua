local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.updatetime = 100
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 99999
vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.colorcolumn = "80"
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = false

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true

require("lazy").setup({
	spec = {
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			lazy = false,
			config = function()
				vim.cmd.colorscheme("catppuccin")
			end,
		},
		{
			"wakatime/vim-wakatime",
			lazy = false,
		},
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			opts = {
				panel = {
					enabled = false,
				}
			}
		},
		{
			"lewis6991/gitsigns.nvim",
			opts = {}
		},
		{
			"mg979/vim-visual-multi",
			event = "BufEnter",
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "echasnovski/mini.icons" },
			opts = {},
			keys = {
				{ "<C-p>", "<cmd>FzfLua files<CR>",     desc = "FzfLua Files" },
				{ "<C-[>", "<cmd>FzfLua live_grep<CR>", desc = "FzfLua Live Grep" },
			}
		},
		{
			'stevearc/oil.nvim',
			opts = {
				view_options = {
					show_hidden = true,
				},
				keymaps = {
					["<C-v>"] = { "actions.select", opts = { vertical = true } },
					["<C-x>"] = { "actions.select", opts = { horizontal = true } },
				},
			},
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
			keys = {
				{
					"<C-e>",
					function()
						if vim.bo.filetype == "oil" then
							require("oil").close()
						else
							require("oil").open()
						end
					end,
					desc = "Toggle Oil"
				},
			}
		}
	},
	install = {
		missing = true,
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = true,
	},
})
