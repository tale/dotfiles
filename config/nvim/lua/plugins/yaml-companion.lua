return {
	"someone-stole-my-name/yaml-companion.nvim",
	event = "LspAttach",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		require("yaml-companion").setup({
			schemas = {
				{
					name = "Kubernetes 1.27.0",
					uri =
					"https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.0-standalone-strict/all.json"
				}
			}
		})

		require("telescope").load_extension("yaml_schema")
	end
}
