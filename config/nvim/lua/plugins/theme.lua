return {
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		name = "github-theme",
		opts = {
			options = {
				transparent = true,
				dim_inactive = false,
				styles = {
					comments = "italic",
					keywords = "bold",
				},
				modules = {
					"cmp",
					"diagnostic",
					"gitsigns",
					"indent_blankline",
					"native_lsp",
					"telescope",
					"treesitter",
					"treesitter_context",
					"neogit",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		priority = 10,
		dependencies = {
			"linrongbin16/lsp-progress.nvim",
		},
		config = function()
			local Color = require("github-theme.lib.color")
			local spec = require("github-theme.spec").load("github_dark_tritanopia")

			local tint = function(color)
				return {
					a = {
						bg = color,
						fg = spec.bg1,
					},
					b = {
						bg = Color(spec.bg1):blend(Color(color), 0.2):to_css(),
						fg = Color(spec.bg1):blend(Color(color), 0.8):to_css(),
					},
					c = {
						bg = nil,
						fg = Color(spec.bg1):blend(Color(color), 0.6):to_css(),
					},
				}
			end

			require("lsp-progress").setup({
				client_format = function(client_name, spinner, series_messages)
					if #series_messages == 0 then
						return client_name
					end

					return (client_name .. " (" .. spinner .. " " .. table.concat(series_messages, ", ")) .. ")"
				end,
				format = function(client_messages)
					if #client_messages == 0 then
						return ""
					end

					return table.concat(client_messages, " ")
				end,
			})

			require("lualine").setup({
				options = {
					icons_enabled = true,
					disabled_filetypes = {
						"oil",
						"terminal",
						"NeogitCommitMessage",
						"NeogitCommitView",
						"NeogitLog",
						"NeogitMergeMessage",
						"NeogitRebaseTodo",
						"NeogitStatus",
						"",
					},
					theme = {
						normal = tint(spec.palette.blue.base),
						insert = tint(spec.palette.green.base),
						command = tint(spec.palette.magenta.bright),
						visual = tint(spec.palette.yellow.base),
						replace = tint(spec.palette.red.base),
						terminal = tint(spec.palette.orange),
						inactive = tint("NONE"),
					},
					component_separators = "|",
					section_separators = {
						left = "",
						right = "",
					},
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(string)
								return string:sub(1, 1)
							end,
						},
					},
					lualine_b = {
						{
							"filename",
							path = 1,
							shorting_target = 50,
						},
					},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {
						{
							function()
								return require("lsp-progress").progress()
							end,
							cond = function()
								local filetype = vim.api.nvim_buf_get_option(0, "filetype")
								local clients = vim.lsp.get_active_clients()
								if next(clients) == nil then
									return false
								end

								for _, client in ipairs(clients) do
									local filetypes = client.config.filetypes
									if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
										return true
									end
								end

								return false
							end,
						},
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							sections = { "error", "warn", "info", "hint" },
							colored = true,
							update_in_insert = true,
						},
					},
					lualine_z = {
						{
							function()
								return "No LSP"
							end,
							cond = function()
								local filetype = vim.api.nvim_buf_get_option(0, "filetype")
								local clients = vim.lsp.get_active_clients()
								if next(clients) == nil then
									return true
								end

								for _, client in ipairs(clients) do
									local filetypes = client.config.filetypes
									if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
										return false
									end
								end

								return true
							end,
							color = tint(spec.palette.red.base).b,
						},
					},
				},
				inactive_sections = {},
				tabline = {},
				extensions = {},
			})
		end,
	},
}
