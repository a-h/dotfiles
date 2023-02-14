local function testAll()
  local testCommands = {
    go = "go test -cover --coverprofile=coverage.out ./...",
  }
  local cmd = testCommands[vim.bo.filetype]
  if cmd ~= nil then
    vim.cmd("!" .. cmd)
  else
    print("no test command for filetype: " .. vim.bo.filetype)
  end
end

vim.api.nvim_create_user_command('TestAll', testAll, {})

-- nvim test.
local nvimtest = require('nvim-test')
require('nvim-test.runners.go-test'):setup {
  args = { "test", "-v", "-cover", "-coverprofile", "coverage.out" },
}
nvimtest.setup()

-- coverage configuration.
local coverage = require("coverage")
coverage.setup({
  auto_reload = true,
})
