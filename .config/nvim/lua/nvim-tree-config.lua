require("nvim-web-devicons").setup()
require("nvim-tree").setup({
  update_focused_file = { enable = true },
  actions = {
    open_file = {
      quit_on_open = true
    }
  }
})

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
