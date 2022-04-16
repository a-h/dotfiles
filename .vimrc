filetype plugin indent on
" Switch off detection of gmi files as "conf".
au BufRead,BufNewFile *.gmi set filetype=gemini
au BufRead,BufNewFile *.metal setfiletype metal

" Move the preview screen.
set splitbelow

" Change how vim represents characters on the screen.
set encoding=utf-8
set fileencoding=utf-8
" Enable syntax highlighting.
syntax on
" Set line numbers to be visible all of the time.
:set nu

" See https://shapeshed.com/vim-netrw for using netrm instead of NerdTree.
" Just use :E to open the explorer.
" Use :e to edit a file.
" Disable banner on newrw file view
let g:netrw_banner = 0
" Use the expandable list style.
let g:netrw_liststyle = 3

" instant.nvim configuration.
let g:instant_username="a-h"

" FZF to replace ctrlP
nnoremap <silent> <C-p> :GFiles<CR>

" Make it so that the gutter (left column) doesn't move.
set signcolumn=yes

" Snippets management.
" Easy grep. 
" :Grep [arg] to search (\vv to search for word under cursor)
" :Replace [target] [replacement] to replace across all files (\vr to replace
" word under cursor)

" vim-easygrep config.
let g:EasyGrepRoot="repository"
let g:EasyGrepRecursive=1
let g:EasyGrepCommand='rg'

" Set colors.
" To find available colours to set, use `:hi <name>` to search through
" available colours.
highlight Normal ctermfg=white ctermbg=black
hi LineNr ctermfg=lightgray
hi Comment ctermfg=green
hi Statement ctermfg=lightblue
hi Constant ctermfg=LightGray
hi PMenu ctermfg=white ctermbg=darkgray
hi PMenuSel ctermfg=white ctermbg=lightgray 
hi Label ctermfg=yellow
hi StatusLine ctermbg=white ctermfg=darkgray
hi MatchParen ctermbg=red
hi Type ctermfg=lightblue
" Diagnostic errors.
hi DiagnosticError ctermfg=red ctermbg=red
hi DiagnosticWarning ctermfg=yellow ctermbg=yellow

" Run xc tasks.
:map <leader>xc :call fzf#run({'source':'xc -short', 'options': '--prompt "xc> " --preview "xc -md {}"', 'sink': 'RunInInteractiveShell xc', 'window': {'width': 0.9, 'height': 0.6}})

" Autoformat Go files on save and add goimports style fix-up.
" See https://github.com/neovim/nvim-lspconfig/issues/115
lua <<EOF
    function org_imports(wait_ms)
      local params = vim.lsp.util.make_range_params()
      params.context = {only = {"source.organizeImports"}}
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit)
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
  end
EOF

augroup GO_LSP
	autocmd!
	autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync()
	autocmd BufWritePre *.go :silent! lua org_imports(3000)
augroup END

" https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
lua << EOF
local nvim_lsp = require('lspconfig')

-- https://github.com/ray-x/lsp_signature.nvim
lsp_signature_cfg = {
  debug = false, -- set to true to enable debug logging
  log_path = "debug_log_file_path", -- debug log path
  verbose = false, -- show debug line number

  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap
  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = false, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                   -- to view the hiding contents
  max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "none"   -- double, rounded, single, shadow, none
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {"(", ","}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = ' ', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}
require'lsp_signature'.setup(lsp_signature_cfg) -- no need to specify bufnr if you don't use toggle_key

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Add templ configuration.
local configs = require'lspconfig.configs'
configs.templ = {
  default_config = {
    cmd = {"templ", "lsp"},
    filetypes = {'templ'},
    root_dir = nvim_lsp.util.root_pattern("go.mod", ".git"),
    settings = {},
  };
}

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'ccls', 'cmake', 'tsserver', 'templ', 'rls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
	if not entry then
	  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	end
	cmp.confirm()
      elseif luasnip.expand_or_jumpable() then
	luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- jdtls is a pain.
nvim_lsp["jdtls"].setup {
  cmd = { "jdtls" },
  on_attach = on_attach,
  capabilies = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  root_dir = nvim_lsp.util.root_pattern("Makefile", ".git", "build.gradle"),
}

--TODO: Work out what keybinding I want to see the big version.
--vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-line-diagnostics-automatically-in-hover-window
-- vim.o.updatetime = 100
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]

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
EOF

" vim-test configuration.
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" coverage configuration.
" https://github.com/ruanyl/coverage.vim configuration
" Specify the path to `coverage.json` file relative to your current working directory.
let g:coverage_json_report_path = 'coverage/coverage-final.json'
" Define the symbol display for covered lines
let g:coverage_sign_covered = '⦿'
" Define the interval time of updating the coverage lines
let g:coverage_interval = 5000
" Do not display signs on covered lines
let g:coverage_show_covered = 1
" Display signs on uncovered lines
let g:coverage_show_uncovered = 1

" https://github.com/rafaelsq/nvim-goc.lua
lua <<EOF
	vim.opt.switchbuf = 'useopen'
	local goc = require'nvim-goc'
	goc.setup({ verticalSplit = false })

	vim.api.nvim_set_keymap('n', '<Leader>gcr', ':lua require("nvim-goc").Coverage()<CR>', {silent=true})
	vim.api.nvim_set_keymap('n', '<Leader>gcc', ':lua require("nvim-goc").ClearCoverage()<CR>', {silent=true})
	vim.api.nvim_set_keymap('n', '<Leader>gct', ':lua require("nvim-goc").CoverageFunc()<CR>', {silent=true})
	vim.api.nvim_set_keymap('n', '<Leader>gca', ':lua cf(false)<CR><CR>', {silent=true})
	vim.api.nvim_set_keymap('n', '<Leader>gcb', ':lua cf(true)<CR><CR>', {silent=true})

	_G.cf = function(testCurrentFunction)
	  local cb = function(path)
	    if path then
	      vim.cmd(":silent exec \"!xdg-open " .. path .. "\"")
	    end
	  end

	  if testCurrentFunction then
	    goc.CoverageFunc(nil, cb, 0)
	  else
	    goc.Coverage(nil, cb)
	  end
	end
EOF
