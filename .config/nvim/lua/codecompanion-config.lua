require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "copilot",
    },
  },
})
