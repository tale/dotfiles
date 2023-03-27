return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = {
		"j-hui/fidget.nvim"
	},
	config = function()
		require("fidget").setup({})
		require("lualine").setup({
			options = {
				icons_enabled = true,
				disabled_filetypes = {
					"neo-tree",
					"terminal",
					"lazygit",
					""
				},
				component_separators = "|",
				section_separators = {
					left = "",
					right = ""
				},
				theme = "ayu",
			},
			sections = {
				lualine_a = {
					{
						"mode",
						right_padding = 2,
						separator = {
							left = "",
						},
					}
				},
				lualine_b = { "filename", "branch" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
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
						color = {
							fg = "#ea6c6d",
							gui = "bold",
						},
					},
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						colored = true,
						update_in_insert = true,
					},
					"filetype",
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
					}
				},
				lualine_z = {
					{
						"location",
						left_padding = 2,
						separator = {
							right = "",
						},
					}
				}
			},
			inactive_sections = {},
			tabline = {},
			extensions = {}
		})
	end
}
