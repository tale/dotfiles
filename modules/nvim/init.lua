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
vim.opt.completeopt = "fuzzy,menu,menuone,noselect,popup"

vim.pack.add({
  "https://github.com/sainnhe/everforest",
  "https://github.com/wakatime/vim-wakatime",
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
})

vim.g.everforest_transparent_background = 2
vim.g.everforest_background = "soft"
vim.cmd.colorscheme("everforest")

require("mini.icons").setup()
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 500 },
})

require("fzf-lua").setup({ "default" })
require("oil").setup({
  view_options = { show_hidden = true },
  keymaps = {
    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
    ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-e>"] = { "actions.close", mode = "n" },
  },
})

require("copilot").setup({
  filetypes = { ["*"] = true, help = false, gitcommit = false, oil = false },
  suggestion = {
    auto_trigger = true,
    hide_during_completion = false,
    keymap = { accept = "<M-CR>" },
  },
  panel = { enabled = false, keymap = { open = "<M-l>" } },
})

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
})

-- Big monorepos choke Neovim's libuv-based file watcher. Every enabled LSP
-- server has its own watcher, so disabling dynamic registration here removes
-- the duplicate work that was causing rust-analyzer / tsgo to hang or die.
vim.lsp.config("*", {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    },
  },
})

vim.lsp.enable({
  "astro",
  "clangd",
  "eslint",
  "gopls",
  "jdtls",
  "lua_ls",
  "oxlint",
  "rust_analyzer",
  "tailwindcss",
  "tinymist",
  "tsgo",
  "yamlls",
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "oxlint", "oxfmt" },
    javascriptreact = { "oxlint", "oxfmt" },
    typescript = { "oxlint", "oxfmt" },
    typescriptreact = { "oxlint", "oxfmt" },
    json = { "oxfmt" },
    yaml = { "oxfmt" },
    markdown = { "oxfmt" },
    lua = { "stylua" },
  },
  default_format_opts = { timeout_ms = 1000, lsp_format = "fallback" },
  format_on_save = function(bufnr)
    if not vim.b[bufnr].no_format then
      return {}
    end
  end,
  formatters = {
    oxfmt = { require_cwd = true },
    oxlint = { require_cwd = true },
    stylua = { require_cwd = true },
  },
})

vim.api.nvim_create_user_command("W", function()
  vim.b.no_format = true
  vim.cmd.write()
  vim.b.no_format = false
end, { desc = "Write file without formatting" })

vim.keymap.set("n", "<Leader>k", vim.diagnostic.open_float)
vim.keymap.set({ "n", "v" }, "<C-CR>", vim.lsp.buf.code_action)
vim.keymap.set("n", "<S-r>", vim.lsp.buf.rename)
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<C-[>", require("fzf-lua").live_grep)
vim.keymap.set("n", "<C-p>", require("fzf-lua").files)
vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>")

require("blink.cmp").setup({ signature = { enabled = true } })
