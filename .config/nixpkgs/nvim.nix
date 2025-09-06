{ pkgs, ... }:

let
  pluginGit = owner: repo: ref: sha: pkgs.vimUtils.buildVimPlugin {
    pname = "${repo}";
    version = ref;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = ref;
      sha256 = sha;
    };
    meta.doCheck = false;
  };

  pluginGitNoCheck = owner: repo: ref: sha: pkgs.vimUtils.buildVimPlugin {
    pname = "${repo}";
    version = ref;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = ref;
      sha256 = sha;
    };
    doCheck = false;
    meta.doCheck = false;
  };

  nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

in
pkgs.neovim.override {
  vimAlias = true;
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        outline-nvim
        copilot-vim
        (pluginGitNoCheck "olimorris" "codecompanion.nvim" "v17.21.0" "sha256-OvmdqjeHab4YhTS7WP4flKliXCt92oKKUJ/IQSLRSkE=")
        lualine-nvim
        dracula-nvim
        # Metal syntax highlighting.
        (pluginGit "stewartimel" "Metal-Vim-Syntax-Highlighting" "f2d69c2a048394bc47ad2b02dd9abc9cb89ee6c1" "sha256-XifdXHgTtGlKqk6oN8BbZku2eMGs8FQHID1Kh65DnFA=")
        # Add fuzzy searching (Ctrl-P to search file names, space-p to search content).
        fzf-vim
        # Maintain last location in files.
        vim-lastplace
        # Syntax highlighting for Nix files.
        vim-nix
        # Colour scheme.
        # Use :TSHighlightCapturesUnderCursor to see the syntax under cursor.
        playground
        # Tressiter syntax highlighting.
        nvim-treesitter-with-plugins
        # Code coverage
        plenary-nvim
        nvim-coverage
        # Grep plugin to improve grep UX.
        (pluginGit "dkprice" "vim-easygrep" "d0c36a77cc63c22648e792796b1815b44164653a" "sha256-bL33/S+caNmEYGcMLNCanFZyEYUOUmSsedCVBn4tV3g=")
        # Templ highlighting.
        (pluginGit "vrischmann" "tree-sitter-templ" "47594c5cbef941e6a3ccf4ddb934a68cf4c68075" "sha256-Dy/6XxrAUrLwcYTYOhLAU6iZb8c5XgplB/AdZbq0S9c=")
        # Add function signatures to autocomplete.
        lsp_signature-nvim
        # Configure autocomplete.
        nvim-cmp
        # Configure autocomplete.
        nvim-lspconfig
        # Snippets manager.
        luasnip
        # Add snippets to the autocomplete.
        cmp_luasnip
        # Show diagnostic errors inline.
        trouble-nvim
        # Go debugger.
        (pluginGit "sebdah" "vim-delve" "41d6ad294fb6dd5090f5f938318fc4ed73b6e1ea" "sha256-wMDTMMvtjkPaWtlV6SWlQ5B7YVsJ4gjPZKPactW8HAE=")
        # Replacement for netrw.
        nvim-web-devicons
        nvim-tree-lua
        # \c to toggle commenting out a line.
        nerdcommenter #preservim/nerdcommenter
        # Work out tabs vs spaces etc. automatically.
        vim-sleuth #tpope/vim-sleuth
        # Change surrounding characters, e.g. cs"' to change from double to single quotes.
        vim-surround #tpope/vim-surround
        nvim-test
        vim-visual-multi #mg979/vim-visual-multi
        cmp-nvim-lsp
        targets-vim # https://github.com/wellle/targets.vim
      ];
      opt = [ ];
    };
    customRC = "lua require('init')";
  };
}
