-- Copilot chat
local chat = require('CopilotChat')
local select = require('CopilotChat.select')

chat.setup({
  log_level = 'info',
  model = 'claude-3.5-sonnet',

  question_header = ' ' .. '🤔' .. ' ',
  answer_header = ' ' .. '🤖' .. ' ',
  error_header = ' ' .. '🚨' .. ' ',
  selection = select.visual,
  mappings = {
    reset = {
      normal = '',
      insert = '',
    },
  },
  prompts = {
    Explain = {
      mapping = '<leader>ae',
      description = 'AI Explain',
    },
    Review = {
      mapping = '<leader>ar',
      description = 'AI Review',
    },
    Tests = {
      mapping = '<leader>at',
      description = 'AI Tests',
    },
    Fix = {
      mapping = '<leader>af',
      description = 'AI Fix',
    },
    Optimize = {
      mapping = '<leader>ao',
      description = 'AI Optimize',
    },
    Docs = {
      mapping = '<leader>ad',
      description = 'AI Documentation',
    },
    Commit = {
      mapping = '<leader>ac',
      description = 'AI Generate Commit',
    },
  },
})

vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Model' })
vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
  vim.ui.input({
    prompt = 'AI Question> ',
  }, function(input)
    if input and input ~= '' then
      chat.ask(input)
    end
  end)
end, { desc = 'AI Question' })
