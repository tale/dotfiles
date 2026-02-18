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

vim.cmd.filetype("plugin indent on")
vim.opt.completeopt = "fuzzy,menu,menuone,noselect,popup"

vim.pack.add({
	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/wakatime/vim-wakatime",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1")
	}
})

vim.cmd.colorscheme("carbonfox")
require("mini.icons").setup()

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500
	}
})

require("snacks").setup({ picker = { enabled = true } })
vim.keymap.set("n", "<C-[>", Snacks.picker.grep)
vim.keymap.set("n", "<C-p>", function()
	Snacks.picker.files({ hidden = true })
end)

vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>")
require("oil").setup({
	view_options = { show_hidden = true },
	keymaps = {
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["<C-s>"] = { "actions.select", opts = { horizontal = true } },
		["<C-e>"] = { "actions.close", mode = "n" },
	}
})

require("copilot").setup({
	filetypes = {
		["*"] = true,
		["help"] = false,
		["gitcommit"] = false,
		["oil"] = false
	},
	suggestion = {
		auto_trigger = true,
		hide_during_completion = false,
		keymap = {
			accept = "<M-CR>"
		}
	},
	panel = {
		enabled = false,
		keymap = {
			open = "<M-l>"
		}
	}
})

vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = { current_line = true },
})

vim.lsp.enable({
	"astro",
	"biome",
	"clangd",
	"eslint",
	"gopls",
	"jdtls",
	"rust_analyzer",
	"tailwindcss",
	"tsgo",
	"yamlls"
})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "oxfmt", "prettierd", "biome-check" },
		typescript = { "oxfmt", "prettierd", "biome-check" },
		typescriptreact = { "oxfmt", "prettierd", "biome-check" },
		json = { "oxfmt" },
		yaml = { "oxfmt" },
	},
	format_on_save = function(bufnr)
		if not vim.g.no_format and not vim.b[bufnr].no_format then
			return { timeout_ms = 2500, lsp_format = "first" }
		end
	end,
	formatters = {
		prettierd = { require_cwd = true },
		["biome-check"] = { require_cwd = true },
		oxfmt = { require_cwd = true }
	}
})

vim.api.nvim_create_user_command("FormatEnable", function(args)
	if args.bang then
		vim.b.no_format = false
		print("Enabled format on save for this buffer")
	else
		vim.g.no_format = false
		print("Enabled format on save")
	end
end, {
	desc = "Enable format on save",
	bang = true
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.no_format = true
		print("Disabled format on save for this buffer")
	else
		vim.g.no_format = true
		print("Disabled format on save")
	end
end, {
	desc = "Disable format on save",
	bang = true
})

vim.api.nvim_create_user_command("W", function()
	vim.b.disable_autoformat = true
	vim.cmd.write()
	vim.b.disable_autoformat = false
end, { desc = "Write file without formatting" })

vim.keymap.set("n", "<Leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "<C-CR>", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("v", "<C-CR>", "<cmd>lua vim.lsp.buf.range_code_action()<CR>")
vim.keymap.set("n", "<S-r>", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "<Leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<Leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "<Leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

require("blink.cmp").setup({ signature = { enabled = true } })
