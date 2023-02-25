return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim"
	},
	config = function()
		-- Disable v1 commands from neo-tree
		vim.g.neo_tree_remove_legacy_commands = 1

		vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
		vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
		vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
		vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

		-- Command + Shift + E for file explorer
		vim.keymap.set("n", "<D-s-e>", ":Neotree<CR>")

		require("neo-tree").setup({
			filesystem = {
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					never_show = {
						".DS_Store"
					}
				}
			}
		})
	end
}
