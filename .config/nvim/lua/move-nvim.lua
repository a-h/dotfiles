-- Move down / up.
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>m.-2<cr>==", { noremap = true })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { noremap = true })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { noremap = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { noremap = true })
