local nvim_lsp = require('lspconfig')

-- https://github.com/ray-x/lsp_signature.nvim
local lsp_signature_cfg = {
  hint_prefix = '',
  handler_opts = {
    border = "none"
  },
  padding = ' '
}
require 'lsp_signature'.setup(lsp_signature_cfg) -- no need to specify bufnr if you don't use toggle_key

-- Format on save.
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Mappings.
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)
  buf_set_keymap('n', '<space>clr', '<cmd>lua vim.lsp.codelens.refresh()<CR>', opts)
  buf_set_keymap('n', '<space>cln', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)
  -- TypeScript organise imports.
  buf_set_keymap('n', '<space>tsoi',
    '<cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>'
    , opts)
  buf_set_keymap('n', '<space>tsf', '<cmd>EslintFixAll<CR>', opts)
end

-- Add templ configuration.
local configs = require('lspconfig.configs')
configs.templ = {
  default_config = {
    --cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/Users/adrian/templ.log", "-goplsLog=/Users/adrian/gopls.log" },
    cmd = { "templ", "lsp" },
    filetypes = { 'templ' },
    root_dir = nvim_lsp.util.root_pattern("go.mod", ".git"),
    settings = {},
  },
}
-- Java language server.
configs.jdtls = {
  default_config = {
    cmd = { "jdtls" },
    filetypes = { 'java' },
    root_dir = nvim_lsp.util.root_pattern("Makefile", ".git", "build.gradle"),
  },
}

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local server_settings = {
  nil_ls = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      }
    }
  },
  gopls = {
    gopls = {
      codelenses = {
        generate = true,   -- show the `go generate` lens.
        gc_details = true, -- show a code lens toggling the display of gc's choices.
        test = true,
        upgrade_dependency = true,
        tidy = true,
      },
    },
  },
  tsserver = {
    format = { enable = false },
  },
  eslint = {
    enable = true,
    format = { enable = true }, -- this will enable formatting
    packageManager = "npm",
    autoFixOnSave = true,
    codeActionOnSave = {
      mode = "all",
      rules = { "!debugger", "!no-only-tests/*" },
    },
    lintTask = {
      enable = true,
    },
  },
  lua_ls = {
    Lua = {
      runtime = {
        version = 'Lua 5.4',
        nonstandardSymbol = { "+=", "-=", "*=", "/=" },
      },
      diagnostics = {
        globals = { 'playdate', 'import', 'vim' },
      },
      workspace = {
        library = { "/Users/adrian/Developer/PlaydateSDK/CoreLibs" },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- eslint comes from:
-- npm i -g vscode-langservers-extracted
local servers = { 'gopls', 'ccls', 'cmake', 'tsserver', 'templ', 'rls', 'eslint', 'lua_ls', 'jdtls', 'terraformls',
  'tflint', 'pylsp', 'nil_ls', 'yamlls' }
for _, lsp in ipairs(servers) do
  local lsp_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
  if server_settings[lsp] then lsp_opts.settings = server_settings[lsp] end
  nvim_lsp[lsp].setup(lsp_opts)
end
--vim.lsp.set_log_level("debug")
--Use :lua vim.lsp.set_log_level("debug") to enable debug logging interactively.
-- Use :LspLog to see logs.

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    completion = {
      border = { "", "", "", "", "", "", " ", "" },
      winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
    },
    documentation = {
      border = { "", "", "", "", "", "", "", "" },
      winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
    },
  },
  mapping = {
    ['<tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        cmp.mapping.scroll_docs(-4)
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        cmp.mapping.scroll_docs(4)
        fallback()
      end
    end, { 'i', 's' }),
  },
  preselect = cmp.PreselectMode.None,
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
}

-- https://github.com/samhh/dotfiles/blob/ba63ff91a33419dfb08e412a7d832b2aca38148c/home/.config/nvim/plugins.vim#L151
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
  }
)

-- Copilot setup.
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
-- Accept the current completion with Ctrl-].
vim.keymap.set('i', '<C-]>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
-- Accept the current completion word with Ctrl-\.
vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-accept-word)')
-- Accept the current completion line with Ctrl-|.
vim.keymap.set('i', '<C-|>', '<Plug>(copilot-accept-line)')
-- Request a suggestion with Ctrl-.
vim.keymap.set('i', '<C-.>', '<Plug>(copilot-suggest)')
