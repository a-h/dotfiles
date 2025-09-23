-- https://github.com/folke/trouble.nvim
require("trouble").setup {
  icons = {
    indent = { top = "", middle = "", last = "", fold_open = "", fold_closed = "", ws = "" },
    folder_closed = "",
    folder_open = "",
    kinds = {},
  },
}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=1<cr>")
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>")
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>")
map("n", "gR", "<cmd>Trouble lsp references toggle<cr>")
