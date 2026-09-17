vim.g.mapleader = " "
vim.opt.updatetime = 100
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 99999
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
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
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter",
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

local ts = require("nvim-treesitter")
local stable, pending = nil, {}

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang then
      return
    end

    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
      return
    end

    stable = stable or ts.get_available(1)
    if pending[lang] or not vim.tbl_contains(stable, lang) then
      return
    end

    pending[lang] = true
    ts.install(lang):await(function(err)
      vim.schedule(function()
        if not err and vim.api.nvim_buf_is_valid(args.buf) then
          vim.treesitter.start(args.buf, lang)
        end
      end)
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork" },
  callback = function(args)
    vim.bo[args.buf].expandtab = false
    vim.bo[args.buf].tabstop = 4
    vim.bo[args.buf].softtabstop = 4
    vim.bo[args.buf].shiftwidth = 4
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
})

vim.lsp.config("jdtls", {
  settings = {
    java = {
      import = { gradle = { enabled = true } },
      configuration = { updateBuildConfiguration = "automatic" },
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
  "sourcekit",
  "tailwindcss",
  "tsgo",
  "yamlls",
})

require("conform").setup({
  formatters_by_ft = {
    go = { "goimports" },
    java = { lsp_format = "never" },
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
    oxlint = {
      require_cwd = true,
      cwd = require("conform.util").root_file({
        ".oxlintrc.json",
        "oxlint.config.ts",
      }),
    },
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
