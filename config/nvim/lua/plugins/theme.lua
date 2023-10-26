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
				hide_end_of_buffer = true,
				hide_nc_statusline = true,
				styles = {
					comments = "italic",
					keywords = "bold",

				},
				darken = {
					floats = false
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
			groups = {
				all = {
					StatusLine = { bg = 'NONE', fg = 'fg0' },
					StatusLineNC = { bg = 'NONE', fg = 'bg1', sp = 'bg0' },
					StatusLineTerm = { link = 'StatusLine' },
					StatusLineTermNC = { link = 'StatusLineNC' }
				}
			}
		},
		config = function(_, opts)
			require("github-theme").setup(opts)

			local function mode()
				local current_mode = vim.api.nvim_get_mode().mode
				return string.format(" %s ", current_mode:upper())
			end

			local function file()
				local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
				local fname = vim.fn.expand "%:t"

				if fpath == "" or fpath == "." then
					fpath = ""
				end

				if fname == "" then
					fname = ""
				end

				return string.format(" %%<%s/%s", fpath, fname)
			end

			local function lsp()
				local count = {}
				local levels = {
					errors = "Error",
					warnings = "Warn",
					info = "Info",
					hints = "Hint",
				}

				for k, level in pairs(levels) do
					count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
				end

				local errors = ""
				local warnings = ""
				local hints = ""
				local info = ""

				if count["errors"] ~= 0 then
					errors = " %#DiagnosticSignError# " .. count["errors"]
				end
				if count["warnings"] ~= 0 then
					warnings = " %#DiagnosticSignWarning# " .. count["warnings"]
				end
				if count["hints"] ~= 0 then
					hints = " %#DiagnosticSignHint# " .. count["hints"]
				end
				if count["info"] ~= 0 then
					info = " %#DiagnosticSignInformation# " .. count["info"]
				end

				return errors .. warnings .. hints .. info .. "%#Normal#"
			end

			local function filetype()
				local icon, color = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)

				if icon ~= nil and color ~= nil then
					return string.format(" %%#%s#%s %s ", color, icon, vim.bo.filetype)
				end

				return string.format(" %s ", vim.bo.filetype)
			end

			local function lineinfo()
				if vim.bo.filetype == "alpha" then
					return ""
				end

				return "%l:%c"
			end

			Statusline = function()
				return table.concat {
					"%#Statusline#",
					mode(),
					"%#Statusline# ",
					file(),
					"%#Statusline#",
					lsp(),
					"%=%#StatusLineExtra#",
					filetype(),
					"%#Statusline#",
					lineinfo(),
				}
			end

			vim.o.statusline = "%!v:lua.Statusline()"
			vim.cmd.colorscheme("github_dark_dimmed")
		end,
	}
}
