{ config, pkgs, ... }:

let

  metalVim = pkgs.vimUtils.buildVimPlugin {
    name = "Metal-Vim-Syntax-Highlighting";
    src = pkgs.fetchFromGitHub {
      owner = "tklebanoff";
      repo = "metal-vim";
      rev = "6970494a5490a17033650849f0a1ad07506cef2e";
      sha256 = "14i8q9ikp3v4q7mpid9ir1azfqfm7fbksc65cpp51424clnqcapl";
    };
  };

  nvimGoCoverage = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-goc.lua";
    src = pkgs.fetchFromGitHub {
      owner = "rafaelsq";
      repo = "nvim-goc.lua";
      rev = "7d23d820feeb30c6346b8a4f159466ee77e855fd";
      sha256 = "1b9ri5s4mcs0k539kfhf5zd3fajcr7d4lc0216pbjq2bvg8987wn";
    };
  };

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

  vimTempl = pkgs.vimUtils.buildVimPlugin {
    name = "templ.vim";
    src = pkgs.fetchFromGitHub {
      owner = "Joe-Davidson1802";
      repo = "templ.vim";
      rev = "2d1ca014c360a46aade54fc9b94f065f1deb501a";
      sha256 = "1bc3p0i3jsv7cbhrsxffnmf9j3zxzg6gz694bzb5d3jir2fysn4h";
    };
  };

  # nix-prefetch-url --unpack https://github.com/ray-x/lsp_signature.nvim/archive/f7c308e99697317ea572c6d6bafe6d4be91ee164.tar.gz
  lspSignatureNvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "lsp_signature.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "e65a63858771db3f086c8d904ff5f80705fd962b";
      sha256 = "17qxn2ldvh1gas3i55vigqsz4mm7sxfl721v7lix9xs9bqgm73n1";
    };
  };

  # nix-prefetch-git https://github.com/hrsh7th/nvim-cmp 983453e32cb35533a119725883c04436d16c0120
  nvimCmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "983453e32cb35533a119725883c04436d16c0120";
      sha256 = "0649n476jd6dqd79fmywmigz19sb0s344ablwr25gr23fp46hzaz";
    };
  };

  # nix-prefetch-git https://github.com/neovim/nvim-lspconfig ea29110765cb42e842dc8372c793a6173d89b0c4
  # https://github.com/neovim/nvim-lspconfig/releases/tag/v0.1.2
  nvimLspConfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "ea29110765cb42e842dc8372c793a6173d89b0c4";
      sha256 = "1i1yjk939pxfk9dpv4rh229srx02yxklzwk051a9qprq3hjhwl6v";
    };
  };

  # nix-prefetch-url --unpack https://github.com/L3MON4D3/LuaSnip/archive/e687d78fc95a7c04b0762d29cf36c789a6d94eda.tar.gz 
  luasnip = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "luasnip";
    src = pkgs.fetchFromGitHub {
      owner = "L3MON4D3";
      repo = "LuaSnip";
      rev = "e687d78fc95a7c04b0762d29cf36c789a6d94eda";
      sha256 = "11a9b744cgr3w2nvnpq1bjblqp36klwda33r2xyhcvhzdcz0h53v";
    };
  };

  # nix-prefetch-git https://github.com/saadparwaiz1/cmp_luasnip a9de941bcbda508d0a45d28ae366bb3f08db2e36
  cmpLuasnip = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp_luasnip";
    src = pkgs.fetchFromGitHub {
      owner = "saadparwaiz1";
      repo = "cmp_luasnip";
      rev = "a9de941bcbda508d0a45d28ae366bb3f08db2e36";
      sha256 = "0mh7gimav9p6cgv4j43l034dknz8szsnmrz49b2ra04yk9ihk1zj";
    };
  };

  neovim7Revision = import (builtins.fetchTarball {
    name = "nixos-unstable-2022-09-16";
    url = "https://github.com/nixos/nixpkgs/archive/38e16b192af13ff6cffc8a35a25f390f1e96b585.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/default.nix
    sha256 = "0pcy4s3khmccpz4xv8wfy2crwgxfvc31r9nlgrn8v9pgmm7z40ic";
  }) {};
  neovim7 = neovim7Revision.neovim;

in
  neovim7.override {
  vimAlias = true;
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        metalVim # Metal-Vim-Syntax-Highlighting
        fzf-vim
        vim-lastplace
        vim-nix
        neoformat
        vim-jsx-typescript
        vim-graphql
        nerdcommenter #preservim/nerdcommenter
        vim-sleuth #tpope/vim-sleuth
        vim-surround #tpope/vim-surround
        vim-test #janko/vim-test
        coverage #ruanyl/coverage.vim
        vim-visual-multi #mg979/vim-visual-multi
        easygrep #dkprice/vim-easygrep
        vimTempl
        # https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
        nvimLspConfig #https://neovim.io/doc/user/lsp.html#lsp-extension-example
        nvimCmp
        cmp-nvim-lsp
        cmpLuasnip
        luasnip
        # Add signature to autocomplete.
        lspSignatureNvim
        # Go coverage needs treesitter.
        nvim-treesitter #github.com/nvim-treesitter/nvim-treesitter
        nvimGoCoverage #rafaelsq/nvim-goc.lua
        rust-vim
        targets-vim # https://github.com/wellle/targets.vim
      ];
      opt = [ ];
    };
    customRC = "lua require('init')";
  };
}
