return {
	"stevearc/oil.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		local oil = require("oil")

		oil.setup({
			delete_to_trash = true,
			trash_command = "trash",
			keymaps = {
				["<C-x>"] = function() oil.select({ horizontal = true, close = true }) end,
				["<C-v>"] = function() oil.select({ vertical = true, close = true }) end,
			}
		})

		vim.g.bind_keys({
			{ { "n", "i", "t", "v", "x" }, "<C-e>", function()
				if vim.bo.filetype == "oil" then
					oil.close()
				else
					oil.open()
				end
			end
			}
		})
	end
}
