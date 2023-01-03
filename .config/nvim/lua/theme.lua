-- Set colors.
-- To find available colours to set, use `:hi <name>` to search through
-- available colours.
local dracula = require("dracula")
dracula.setup({
  -- set custom lualine background color
  lualine_bg_color = "#44475a", -- default nil
  transparent_bg = true,
  -- overrides the default highlights see `:h synIDattr`
  overrides = {
    -- Examples
    -- NonText = { fg = dracula.colors().white }, -- set NonText fg to white
    -- NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
    -- Nothing = {} -- clear highlight of Nothing
  },
})
vim.cmd [[colorscheme dracula]]
require('lualine').setup {
  options = {
    theme = 'dracula-nvim'
  }
}
-- Floating window.
vim.cmd [[hi Pmenu guibg=NONE]]
