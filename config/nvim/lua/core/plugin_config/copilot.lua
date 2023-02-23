-- Exported because Copilot needs to be started after the plugins are loaded
return function()
	vim.defer_fn(function()
		require('copilot').setup({
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = '[[',
					jump_next = ']]',
					accept = '<CR>',
					refresh = 'gr',
					open = '<M-l>'
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = '<M-CR>',
					accept_word = false,
					accept_line = false,
					next = '<M-]>',
					prev = '<M-[>',
					dismiss = '<C-]>',
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				['.'] = false,
			}
		})
	end, 1000)
end
