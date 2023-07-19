return {
	"b0o/schemastore.nvim",
	event = "BufRead",
	config = function()
		require("lspconfig").jsonls.setup({
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = {
						enable = true
					}
				}
			}
		})
	end
}
