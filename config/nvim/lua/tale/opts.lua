local o = vim.opt

o.tabstop = 4                      -- Tabs are 4 spaces
o.softtabstop = 4                  -- Tabs are 4 spaces (soft edition)
o.shiftwidth = 4                   -- The number of spaces for each indentation
o.shiftround = true                -- Round indent to multiple of shiftwidth
o.expandtab = false                -- Use tabs instead of spaces
o.colorcolumn = "80"               -- Highlight the 80th column
o.updatetime = 100                 -- Apparently this improves performance

o.relativenumber = true            -- Relative line numbers
o.signcolumn = "yes"               -- Always show the sign column
o.cursorline = true                -- Highlight the line with the cursor
o.showmode = false                 -- Don't show mode in command bar
o.showcmd = false                  -- Don't show the command being typed
o.ruler = false                    -- Don't show the command bar ruler
o.hlsearch = false                 -- Don't highlight search results
o.incsearch = true                 -- Incremental search

o.splitbelow = true                -- Split buffers onto the second child vertically
o.splitright = true                -- Split buffers onto the second child horizontally
o.ignorecase = true                -- Ignore case when searching for a pattern
o.smartcase = true                 -- Disable ignorecase when searching with uppercase

o.mouse = nil                      -- Disable the mouse
o.termguicolors = true             -- Enable 24-bit RGB colors
o.clipboard = "unnamedplus"        -- Use the system clipboard by default
o.autoread = true                  -- Automatically update buffers when files change
o.undofile = true                  -- Save undo history to a file
o.swapfile = false                 -- Disable swap files
o.backup = false                   -- Disable backup files

o.shortmess:append("c")            -- Don't pass messages to |ins-completion-menu|
o.completeopt = "menuone,noselect" -- Completion options

-- Disable providers for languages I don't use
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.m" },
	callback = function()
		vim.bo.filetype = "objc"
	end
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.plist" },
	callback = function()
		vim.bo.filetype = "xml"
	end
})

SLActive = function()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
	local fname = vim.fn.expand "%:t"

	if fpath == "" or fpath == "." then
		fpath = ""
	end

	if fname == "" then
		fname = ""
	end

	local file = string.format("%%<%s/%s", fpath, fname)
	local lsp = ""

	local levels = {
		errors = { name = "Error", icon = "" },
		warnings = { name = "Warn", icon = "" },
		info = { name = "Info", icon = "" },
		hints = { name = "Hint", icon = "" },
	}

	for i in pairs(levels) do
		local level = levels[i]
		local diag_count = vim.tbl_count(vim.diagnostic.get(0, {
			severity = level.name
		}))

		if diag_count > 0 then
			lsp = lsp ..
				" %#" ..
				"DiagnosticSign" ..
				level.name:sub(1, 1):upper() ..
				level.name:sub(2) .. "#" .. level.icon .. " " .. diag_count
		end
	end

	return table.concat({ "%#StatusLineExtra#", file, "%=%#StatusLineExtra#", lsp })
end

vim.cmd.colorscheme("lunaperche")
vim.cmd.hi("Normal guibg=NONE ctermbg=NONE")
vim.cmd.hi("StatusLineExtra guibg=NONE guifg=NONE")

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	pattern = "*",
	callback = function()
		vim.wo.statusline = "%!v:lua.SLActive()"
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	pattern = "*",
	callback = function()
		vim.wo.statusline = "%#StatusLineExtra#"
	end,
})
