-- The nvim-treesitter main branch removed the nvim-treesitter.configs module
-- and its setup{} API. Highlighting is now enabled per buffer with
-- vim.treesitter.start(), triggered on FileType for parsers that are installed.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang then
      return
    end
    if not pcall(vim.treesitter.language.add, lang) then
      return
    end
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
