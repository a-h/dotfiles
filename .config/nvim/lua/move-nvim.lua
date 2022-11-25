local opts = { noremap = true, silent = true }

-- Move down / up.
vim.keymap.set('n', '<A-k>', "<cmd>m --<cr>", opts)
vim.keymap.set('n', '<A-j>', "<cmd>m +1<cr>", opts)
