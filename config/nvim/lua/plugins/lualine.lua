return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
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
				lualine_x = {},
				lualine_y = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						colored = true,
						update_in_insert = true,
					},
					"filetype"
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
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" }
			},
			tabline = {},
			extensions = {}
		})
	end
}
