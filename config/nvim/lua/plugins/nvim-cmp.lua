return {
	"hrsh7th/nvim-cmp",
	event = "BufEnter",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip"
	},
	config = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		vim.diagnostic.config({
			virtual_text = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always"
			}
		})

		-- Force rounded borders on hover and signature help
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
			vim.lsp.handlers.hover,
			{ border = "rounded" }
		)

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{ border = "rounded" }
		)

		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local select_opts = { behavior = cmp.SelectBehavior.Select }
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end
			},
			sources = {
				{ name = "path" },
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "buffer",  keyword_length = 2 },
				{ name = "luasnip", keyword_length = 2 }
			},
			window = {
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },
				format = function(entry, item)
					local menu_icon = {
						nvim_lsp = "λ",
						copilot = "",
						luasnip = "⋗",
						buffer = "Ω",
						path = "𓃊",
					}

					item.menu = menu_icon[entry.source.name]
					return item
				end
			},
			mapping = {
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<Up>"] = cmp.mapping.select_prev_item(select_opts),
				["<Down>"] = cmp.mapping.select_next_item(select_opts),
				["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
				["<C-n>"] = cmp.mapping.select_next_item(select_opts),
				["<C-u>"] = cmp.mapping.scroll_docs( -4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-e>"] = cmp.mapping.abort(),

				-- Jump to next snippet placeholder --
				["<C-f>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Tab based autocompletion --
				["<Tab>"] = cmp.mapping(function(fallback)
					local col = vim.fn.col(".") - 1

					if cmp.visible() then
						cmp.select_next_item(select_opts)
					elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
						fallback()
					else
						cmp.complete()
					end
				end, { "i", "s" }),
			}
		})
	end
}
