vim.g.mapleader = " "

local function bind_keys(bindings)
	for _, binding in ipairs(bindings) do
		local opts = { noremap = true, silent = true }
		vim.keymap.set(binding[1], binding[2], binding[3], opts)
	end
end

bind_keys({
	-- Indentation using Tab and Shift Tab
	{ { "n" }, "<Tab>",   ">>" },
	{ { "n" }, "<S-Tab>", "<<" },
	{ { "i" }, "<Tab>",   "<C-t>" },
	{ { "i" }, "<S-Tab>", "<C-d>" },
	{ { "v" }, "<Tab>",   ">gv" },
	{ { "v" }, "<S-Tab>", "<gv" },

	-- Easy moves
	{ { "v" }, "J",       ":m '>+1<CR>gv=gv" },
	{ { "v" }, "K",       ":m '<-2<CR>gv=gv" }
})
