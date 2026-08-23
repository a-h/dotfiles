-- Use space for leader key.
vim.g.mapleader = ' '

-- Disable netrw (using nvim-tree instead).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use the terminal's 16 ANSI colors instead of hardcoded RGB values. This
-- inherits the palette from the terminal emulator (Dracula, Solarized, etc.)
-- and degrades gracefully in limited terminals like PuTTY.
vim.opt.termguicolors = false
vim.cmd.colorscheme("vim")

-- Setup editor options.
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.signcolumn = "yes"
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
vim.opt.number = true
vim.opt.hlsearch = false
vim.cmd("set mouse=")

-- Use the system clipboard for all yank, delete, and paste operations. The
-- wl-clipboard and xclip providers are baked into the wrapper's PATH, so this
-- works under both Wayland and X11.
vim.opt.clipboard = "unnamedplus"

-- Configure nvim-tree.
require("nvim-tree").setup()
vim.keymap.set("n", "<C-h>", ":NvimTreeToggle<CR>")

-- Configure fzf-lua.
require("fzf-lua").setup()
vim.keymap.set("n", "<leader>p", require("fzf-lua").files)
vim.keymap.set("n", "<leader>P", require("fzf-lua").live_grep)

-- Configure treesitter.
-- nvim-treesitter 0.10.0 removed the configs module; highlighting is now via
-- Neovim's built-in treesitter API.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local ts_select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner", "textobjects") end)

local ts_move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]a", function() ts_move.goto_next_start("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]F", function() ts_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]C", function() ts_move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]A", function() ts_move.goto_next_end("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[a", function() ts_move.goto_previous_start("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[F", function() ts_move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[C", function() ts_move.goto_previous_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[A", function() ts_move.goto_previous_end("@parameter.inner", "textobjects") end)

local ts_swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.inner") end)

-- Configure autocompletion.
require("blink.cmp").setup()

-- Enable LSPs.
vim.lsp.enable("nixd")
vim.lsp.enable("gopls")
vim.lsp.enable("ccls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("terraformls")
vim.lsp.enable("superhtml")
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("jsonls")
vim.lsp.enable("eslint")
vim.lsp.enable("yamlls")
vim.lsp.enable("rust_analyzer")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { remap = false })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- Format on save.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
