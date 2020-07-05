{ config, pkgs, ... }:

let

  coverage = pkgs.vimUtils.buildVimPlugin {
    name = "vim-coverage";
    src = pkgs.fetchFromGitHub {
      owner = "ruanyl";
      repo = "coverage.vim";
      rev = "1d4cd01e1e99d567b640004a8122be8105046921";
      sha256 = "1vr6ylppwd61rj0l7m6xb0scrld91wgqm0bvnxs54b20vjbqcsap";
    };
  };

  easygrep = pkgs.vimUtils.buildVimPlugin {
    name = "vim-easygrep";
    src = pkgs.fetchFromGitHub {
      owner = "dkprice";
      repo = "vim-easygrep";
      rev = "d0c36a77cc63c22648e792796b1815b44164653a";
      sha256 = "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc";
    };
  };

in

{
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
	pkgs.awscli
	pkgs.docker
	pkgs.fzf
	pkgs.git
	pkgs.gitAndTools.gh
	pkgs.gnupg
	pkgs.go
	pkgs.gopass
	pkgs.graphviz
	pkgs.htop
	pkgs.hugo
	pkgs.jq
	pkgs.lynx
	pkgs.nmap
	pkgs.nodejs
	pkgs.ripgrep
        # pkgs.slack # currently broken
	pkgs.terraform
	pkgs.tmux
	pkgs.tree
	pkgs.unzip
	pkgs.wget
	pkgs.yarn
	pkgs.zip
	(
           pkgs.neovim.override {
	      vimAlias = true;
	      configure = {
		packages.myPlugins = with pkgs.vimPlugins; {
                  start = [ 
                    vim-go
                    vim-lastplace 
                    vim-nix 
                    coc-nvim
                    nerdcommenter #preservim/nerdcommenter
                    ctrlp #ctrlpvim/ctrlp.vim
                    vim-sleuth #tpope/vim-sleuth
                    vim-surround #tpope/vim-surround
                    vim-test #janko/vim-test
                    coverage #ruanyl/coverage.vim
                    ultisnips #SirVer/ultisnips
                    vim-snippets #honza/vim-snippets
                    easygrep #dkprice/vim-easygrep # Also missing
                  ]; 
		  opt = [];
		};
		customRC = ''
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
		'';
	    };
	  }
	)
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;
}

