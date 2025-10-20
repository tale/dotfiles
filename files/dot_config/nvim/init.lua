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
	"https://github.com/savq/melange-nvim",
	"https://github.com/wakatime/vim-wakatime",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/stevearc/oil.nvim",

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


vim.cmd.colorscheme("melange")

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500
	}
})
require("fzf-lua").setup({})
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<C-[>", "<cmd>FzfLua live_grep<CR>")

require("oil").setup({
	view_options = {
		show_hidden = true
	},
	keymaps = {
		["<C-v>"] = "actions.select_vsplit",
		["<C-x>"] = "actions.select_split",
	}
})

vim.keymap.set("n", "<C-e>", function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end)

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

		return { timeout_ms = 500, lsp_format = "first" }
	end,
	formatters = {
		prettierd = {
			condition = function(self, ctx)
				local root

				if type(self.cwd) == "function" then
					root = self.cwd(self, ctx)
				elseif type(self.cwd) == "string" then
					root = self.cwd
				end

				local ok = root ~= nil and root ~= false and root ~= ""
				return ok
			end,
		}
	}
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

vim.keymap.set("n", "<Leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "<C-CR>", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("v", "<C-CR>", "<cmd>lua vim.lsp.buf.range_code_action()<CR>")
vim.keymap.set("n", "<S-r>", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "<Leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<Leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "<Leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
