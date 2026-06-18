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

local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-golang")({
      go_test_args = { "-v", "-cover", "-coverprofile=coverage.out" },
    }),
    require("neotest-jest")({
      jestCommand = "npx jest --",
    }),
    require("neotest-vitest"),
    require("neotest-python")({
      runner = "pytest",
    }),
  },
})

vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Test file" })
vim.keymap.set("n", "<leader>ts", function() neotest.run.stop() end, { desc = "Stop test" })
vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Re-run last test" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Test output" })
vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "Toggle test output panel" })
vim.keymap.set("n", "<leader>tt", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })

local coverage = require("coverage")
coverage.setup({
  auto_reload = true,
})
