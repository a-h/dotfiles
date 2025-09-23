-- lsp_signature.nvim
require("lsp_signature").setup {
  hint_prefix = "",
  handler_opts = { border = "none" },
  padding = " ",
}

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function() vim.lsp.buf.format() end,
})

-- diagnostics keymaps
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { silent = true })

-- default capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- buffer-local keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "gD", vim.lsp.buf.declaration, "Declaration")
    map("n", "gd", vim.lsp.buf.definition, "Definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gi", vim.lsp.buf.implementation, "Implementation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    map("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      "List workspace folders")
    map("n", "<space>D", vim.lsp.buf.type_definition, "Type definition")
    map("n", "<space>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<space>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "<space>f", function() vim.lsp.buf.format { async = true } end, "Format")
    map("n", "<space>clr", vim.lsp.codelens.refresh, "CodeLens Refresh")
    map("n", "<space>cln", vim.lsp.codelens.run, "CodeLens Run")
    map("n", "<space>tsoi", function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.fn.expand("%:p") },
      })
    end, "TS Organize Imports")
    map("n", "<space>tsf", "<cmd>EslintFixAll<cr>", "Eslint Fix All")
  end,
})

-- custom servers
vim.lsp.config("templ", {
  cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/Users/adrian/templ.log", "-goplsLog=/Users/adrian/gopls.log" },
  filetypes = { "templ" },
  root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
})

vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  filetypes = { "java" },
  root_dir = require("lspconfig.util").root_pattern("Makefile", ".git", "build.gradle"),
})

-- per-server settings
vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = { command = { "nixpkgs-fmt" } },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        upgrade_dependency = true,
        tidy = true,
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  settings = { format = { enable = false } },
})

vim.lsp.config("eslint", {
  settings = {
    enable = true,
    format = { enable = true },
    packageManager = "npm",
    autoFixOnSave = true,
    codeActionOnSave = {
      mode = "all",
      rules = { "!debugger", "!no-only-tests/*" },
    },
    lintTask = { enable = true },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.4",
        nonstandardSymbol = { "+=", "-=", "*=", "/=" },
      },
      diagnostics = {
        globals = { "playdate", "import", "vim" },
      },
      workspace = {
        library = { "/Users/adrian/Developer/PlaydateSDK/CoreLibs" },
      },
      telemetry = { enable = false },
    },
  },
})

-- enable servers
for _, lsp in ipairs({
  "gopls",
  "ccls",
  "cmake",
  "superhtml",
  "ts_ls",
  "templ",
  "rls",
  "eslint",
  "lua_ls",
  "jdtls",
  "terraformls",
  "tailwindcss",
  "tflint",
  "pylsp",
  "nil_ls",
  "yamlls",
}) do
  vim.lsp.enable(lsp)
end

-- completion
vim.o.completeopt = "menuone,noselect"

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  window = {
    completion = {
      border = { "", "", "", "", "", "", " ", "" },
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
    documentation = {
      border = { "", "", "", "", "", "", "", "" },
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  mapping = {
    ["<Tab>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Down>"]    = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Up>"]      = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.close(),
    ["<CR>"]      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-d>"]     = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        cmp.mapping.scroll_docs(-4)(fallback)
      end
    end, { "i", "s" }),
    ["<C-b>"]     = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        cmp.mapping.scroll_docs(4)(fallback)
      end
    end, { "i", "s" }),
  },
  preselect = cmp.PreselectMode.None,
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
}

-- diagnostics config
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
}

-- copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set("i", "<C-]>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-accept-word)")
vim.keymap.set("i", "<C-|>", "<Plug>(copilot-accept-line)")
vim.keymap.set("i", "<C-.>", "<Plug>(copilot-suggest)")
