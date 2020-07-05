filetype plugin indent on

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

" Snippets management.
" Easy grep. 
" :Grep [arg] to search (\vv to search for word under cursor)
" :Replace [target] [replacement] to replace across all files (\vr to replace
" word under cursor)

" vim-easygrep config.
let g:EasyGrepRoot="repository"
let g:EasyGrepRecursive=1
" use ripgrep (brew install ripgrep)
let g:EasyGrepCommand='rg'

" Set colors.
highlight Normal ctermfg=white ctermbg=black
hi LineNr ctermfg=lightgray
hi Comment ctermfg=lightgreen
hi Statement ctermfg=lightblue
hi Constant ctermfg=LightGray
hi PMenu ctermfg=white ctermbg=darkgray
hi PMenuSel ctermfg=white ctermbg=lightgray 
hi Label ctermfg=yellow
hi StatusLine ctermbg=white ctermfg=darkgray

" ultisnips configuration.
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" vim-go configuration.
" https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876
" Run goimports along gofmt on each save.
let g:go_fmt_command = "goimports"
" Automatically get signature/type info for object under cursor  
let g:go_auto_type_info = 1    
" Add extra syntax highlighting.
" let g:go_highlight_structs = 1 
" let g:go_highlight_methods = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_operators = 0
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_types = 1
" Don't highlight same names.
let g:go_auto_sameids = 0
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------
" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Configure coc prettier.
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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
