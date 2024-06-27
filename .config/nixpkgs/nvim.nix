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
  };

  nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

in
pkgs.neovim.override {
  vimAlias = true;
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        (pluginGit "hedyhli" "outline.nvim" "v1.0.0" "sha256-dxw8KpsWjWWPi2PVflqg+JrK/jPJP9kmnpO5FxC/MZo=")
        (pluginGit "github" "copilot.vim" "v1.34.0" "sha256-FHqlO3Pot89Dy8iW1RQzZNgaXh1mmgEgzY/j/J67Z7Q=")
        (pluginGit "nvim-lualine" "lualine.nvim" "0a5a66803c7407767b799067986b4dc3036e1983" "sha256-WcH2dWdRDgMkwBQhcgT+Z/ArMdm+VbRhmQftx4t2kNI=")
        (pluginGit "Mofiqul" "dracula.nvim" "7200e64c589f899d29f8963aad7543856d1c2545" "sha256-WI88cFQg2ePZZlgt8i/cFB50oGx6GEuuOxneygu3siQ=")
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
        (pluginGit "nvim-treesitter" "playground" "ba48c6a62a280eefb7c85725b0915e021a1a0749" "sha256-gOQr61Y3bVa6EAb0P924X9SJmg9lOmGiLcFTMdgu8u0=")
        # Tressiter syntax highlighting.
        nvim-treesitter-with-plugins
        # Code coverage
        (pluginGit "nvim-lua" "plenary.nvim" "v0.1.4" "sha256-zR44d9MowLG1lIbvrRaFTpO/HXKKrO6lbtZfvvTdx+o=")
        (pluginGit "andythigpen" "nvim-coverage" "cf4b5c61dfac977026a51a2bcad9173c272986ce" "sha256-7Gle8osO4hPB2IGqtsAG+A1IK42BuqBxZVbLxH+sliI=")
        # Grep plugin to improve grep UX.
        (pluginGit "dkprice" "vim-easygrep" "d0c36a77cc63c22648e792796b1815b44164653a" "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc")
        # Templ highlighting.
        (pluginGit "vrischmann" "tree-sitter-templ" "cf84ea53e2e2531f23009d676ac206090c1e2392" "sha256-CQ11t4beqkjhtZktrawuavgQPSFzbwJrU/aSbPsqBPA=")
        # Add function signatures to autocomplete.
        (pluginGit "ray-x" "lsp_signature.nvim" "v0.3.1" "sha256-WAQ8DWjNWKYBbELC/M8ClGxU0cAqB4X1TlkWIEBqp24=")
        # Configure autocomplete.
        (pluginGit "hrsh7th" "nvim-cmp" "5260e5e8ecadaf13e6b82cf867a909f54e15fd07" "sha256-GhXfnWqpXFVM7Yi9+qEXHfA6LIMILcMG9pP4VYXuptE=")
        # Configure autocomplete.
        (pluginGit "neovim" "nvim-lspconfig" "v0.1.8" "sha256-foJ7a59N0a3QaBW24PtwbyYDQVlIsFxiatADLO/hQvc=")
        # Snippets manager.
        (pluginGit "L3MON4D3" "LuaSnip" "v2.3.0" "sha256-E1Ov6aF9DJ0poVM6q6jK1ypsJf6cRzHqC2Gi6u9kai0=")
        # Add snippets to the autocomplete.
        (pluginGit "saadparwaiz1" "cmp_luasnip" "05a9ab28b53f71d1aece421ef32fee2cb857a843" "sha256-nUJJl2zyK/oSwz5RzI9j3gf9zpDfCImCYbPbVsyXgz8=")
        # Show diagnostic errors inline.
        (pluginGit "folke" "trouble.nvim" "v2.10.0" "sha256-8nLghiueYOtWY7OGVxow9A2G/5lgt+Kt5D8q1xeJvVg=")
        # Go debugger.
        (pluginGit "sebdah" "vim-delve" "41d6ad294fb6dd5090f5f938318fc4ed73b6e1ea" "sha256-wMDTMMvtjkPaWtlV6SWlQ5B7YVsJ4gjPZKPactW8HAE=")
        # Replacement for netrw.
        (pluginGit "nvim-tree" "nvim-web-devicons" "8b2e5ef9eb8a717221bd96cb8422686d65a09ed5" "sha256-1Dfc8xbdI6rnUcYH2iqwzD4ZbpD42iZsRHa4cDKF+2g=")
        (pluginGit "nvim-tree" "nvim-tree.lua" "141c0f97c35f274031294267808ada59bb5fb08e" "sha256-duBskC/cSaeqGRe/n0ndRuC+y8oZ0oRYNj3Fm3DcgVg=")
        # \c to toggle commenting out a line.
        nerdcommenter #preservim/nerdcommenter
        # Work out tabs vs spaces etc. automatically.
        vim-sleuth #tpope/vim-sleuth
        # Change surrounding characters, e.g. cs"' to change from double to single quotes.
        vim-surround #tpope/vim-surround
        (pluginGit "klen" "nvim-test" "1.4.1" "sha256-mMi07UbMWmC75DFfW1b+sR2uRPxizibFwS2qcN9rpLI=")
        vim-visual-multi #mg979/vim-visual-multi
        (pluginGit "hrsh7th" "cmp-nvim-lsp" "39e2eda76828d88b773cc27a3f61d2ad782c922d" "sha256-CT1+Z4XJBVsl/RqvJeGmyitD6x7So0ylXvvef5jh7I8=")
        targets-vim # https://github.com/wellle/targets.vim
      ];
      opt = [ ];
    };
    customRC = "lua require('init')";
  };
}
