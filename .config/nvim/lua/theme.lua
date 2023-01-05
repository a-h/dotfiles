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
    ['@type.builtin'] = {
      fg = dracula.colors().cyan,
      italic = false,
    },
  },
})
vim.cmd [[colorscheme dracula]]

-- Floating window.
vim.cmd [[hi Pmenu guibg=NONE]]

-- Lualine setup.
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/config.lua
require('lualine').setup({
  options = {
    theme = 'dracula-nvim'
  },
  extensions = { 'fzf', 'nvim-tree' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
})
