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

vim.pack.add({
	"https://github.com/zenbones-theme/zenbones.nvim",
	"https://github.com/wakatime/vim-wakatime",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/echasnovski/mini.icons",

	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/zapling/mason-conform.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1")
	}
})


vim.g.zenbones_compat = 1
vim.cmd.colorscheme("zenbones")

vim.g.netrw_liststyle = 1
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

vim.api.nvim_set_hl(0, "netrwMarkFile", {})
vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "Search" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		local opts = { buffer = true, remap = true, silent = true }
		vim.keymap.set("n", "<C-e>", "<cmd>bd<CR>", opts)
		vim.keymap.set("n", "<Tab>", "mf", opts)
		vim.keymap.set("n", "<S-Tab>", "mF", opts)
		vim.keymap.set("n", "<C-x>", "<cmd>split<CR><cmd>normal! gf<CR>", opts)
		vim.keymap.set("n", "<C-v>", "<cmd>vsplit<CR><cmd>normal! gf<CR>", opts)
	end
});

require("gitsigns").setup({})
require("fzf-lua").setup({})
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<C-[>", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<C-e>", "<cmd>Explore %:p:h<CR>")

require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		hide_during_completion = false,
		keymap = {
			accept = "<M-CR>"
		}
	},
	panel = {
		enabled = false
	}
})

vim.diagnostic.config({ virtual_text = true })
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"biome",
		"clangd",
		"docker_language_server",
		"eslint",
		"gopls",
		"graphql",
		"rust_analyzer",
		"tailwindcss",
		"ts_ls",
		"yamlls"
	}
})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" }
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end
})

require("mason-conform").setup({})
vim.api.nvim_create_user_command("FormatEnable", function(args)
	if args.bang then
		vim.b.disable_autoformat = false
		print("Enabled format on save for this buffer")
	else
		vim.g.disable_autoformat = false
		print("Enabled format on save")
	end
end, {
	desc = "Enable format on save",
	bang = true
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
		print("Disabled format on save for this buffer")
	else
		vim.g.disable_autoformat = true
		print("Disabled format on save")
	end
end, {
	desc = "Disable format on save",
	bang = true
})

require("blink.cmp").setup({
	signature = {
		enabled = true
	}
})
