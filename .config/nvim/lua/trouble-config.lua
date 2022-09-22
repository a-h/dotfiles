-- https://github.com/folke/trouble.nvim
require("trouble").setup {
  icons = false,
  fold_open = "", -- icon used for open folds
  fold_closed = "", -- icon used for closed folds
  signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = ""
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {silent = true, noremap = true})
