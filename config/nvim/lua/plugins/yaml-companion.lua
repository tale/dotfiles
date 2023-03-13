return {
	"someone-stole-my-name/yaml-companion.nvim",
	event = "BufRead",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		require("yaml-companion").setup({
			schemas = {
				{
					name = "Kubernetes 1.26.1",
					uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.26.1-standalone-strict/all.json"
				}
			}
		})

		require("telescope").load_extension("yaml_schema")
	end
}
