-- FZF to replace ctrlP
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
map("n", "<C-p>", "<cmd>GFiles<cr>", { silent = true, noremap = true })
map("n", "<space>p", "<cmd>Ag<cr>", { silent = true, noremap = true })
map("n", "<space>o", "<cmd>Files<cr>", { silent = true, noremap = true })
