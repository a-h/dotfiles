-- vim-test settings
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
map("n", "t<C-n>", "<cmd>TestNearest<cr>", {silent = true, noremap = true})
map("n", "t<C-f>", "<cmd>TestFile<cr>", {silent = true, noremap = true})
map("n", "t<C-s>", "<cmd>TestSuite<cr>", {silent = true, noremap = true})
map("n", "t<C-l>", "<cmd>TestLast<cr>", {silent = true, noremap = true})
map("n", "t<C-g>", "<cmd>TestVisit<cr>", {silent = true, noremap = true})
