local map = LazyVim.safe_keymap_set

vim.keymap.set("i", "jj", "<ESC>", { silent = true, noremap = true })
vim.keymap.set("n", "H", "^", { noremap = true })
vim.keymap.set("n", "L", "$", { noremap = true })
vim.keymap.set("v", "H", "^", { noremap = true })
vim.keymap.set("v", "L", "$", { noremap = true })

vim.keymap.set("n", "<c-y>", [["0y]], { noremap = true })
vim.keymap.set("v", "<c-y>", [["0y]], { noremap = true })
vim.keymap.set("n", "<c-p>", [["0p]], { noremap = true })
vim.keymap.set("v", "<c-p>", [["0p]], { noremap = true })

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

map({ "n", "t" }, "<c-.>", function()
	Snacks.terminal.toggle(nil, { cwd = LazyVim.root(), win = { position = "float" }, env = { position = "float" } })
end, { desc = "Float Terminal (Root Dir)" })

vim.cmd([[cab cc CodeCompanion]])
