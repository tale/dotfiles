return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local version = vim.version()
		-- Shouldn't be possible, but just in case
		if version == nil then
			version = {
				major = 0,
				minor = 0,
				patch = 0,
			}
		end

		-- There are 2 lines for the buttons and the text is 13 lines
		-- So we subtract half of the value to center the text in the window
		local padding_start = (vim.o.lines / 2) - 1 - 7
		local format = version.major .. "." .. version.minor .. "." .. version.patch
		local topLine = "                 NVIM v" .. format

		require("alpha").setup({
			layout = {
				{
					type = "group",
					val = {
						{
							type = "button",
							val = "",
							opts = {
								keymap = { "n", "<CR>", "<Cmd>:enew<CR>", {} },
							}
						},
						{
							type = "button",
							val = "",
							opts = {
								keymap = { "n", "q", "<Cmd>:q<CR>", {} },
							}
						}

					}
				},
				{
					type = "padding",
					val = padding_start,
				},
				{
					type = "text",
					opts = {
						hl = "Comment",
						position = "center",
					},
					val = {
						topLine,
						[[ ]],
						[[  Nvim is open source and freely distributable ]],
						[[            https://neovim.io/#chat ]],
						[[ ]],
						[[ type  :help nvim<Enter>      if you are new! ]],
						[[ type  :checkhealth<Enter>    to optimize Nvim ]],
						[[ type  :q<Enter>              to exit ]],
						[[ type  :help<Enter>           for help ]],
						[[ ]],
						[[            Sponsor Vim development! ]],
						[[ type  :help sponsor<Enter>   for information ]],
					}
				}
			}
		})

		vim.cmd("Alpha")
	end,
}
