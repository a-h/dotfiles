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
      rev = "7c03112ce77b7df2b124d46c1188cc3c66d06f66";
      sha256 = "1sl3f770aw52cbrqvx96ys741qwk0lv2v39qhmn2lppsp4ymk5bn";
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

  vimBuilder = pkgs.vimUtils.buildVimPlugin {
    name = "builder.vim";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "builder.vim";
      rev = "940e0deff0fb4ff2c4fdfe263cdbe669152688c6";
      sha256 = "1synvwz7xqy68wb45rdy5lscp2z19wdd7wnp07smylv4jcnlya51";
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

  instantNvim = pkgs.vimUtils.buildVimPlugin {
    name = "instant.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "jbyuki";
      repo = "instant.nvim";
      rev = "c02d72267b12130609b7ad39b76cf7f4a3bc9554";
      sha256 = "1wk43a8lnwkvfl0m2bxxgidbj4p03322xvn5j1wsl678xw1gdypc";
    };
  };

  # nix-prefetch-url --unpack https://github.com/ray-x/lsp_signature.nvim/archive/f7c308e99697317ea572c6d6bafe6d4be91ee164.tar.gz
  lspSignatureNvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "lsp_signature.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "f7c308e99697317ea572c6d6bafe6d4be91ee164";
      sha256 = "0s48bamqwhixlzlyn431z7k3bhp0y2mx16d36g66c9ccgrs5ifmm";
    };
  };

  # nix-prefetch-url --unpack https://github.com/hrsh7th/nvim-cmp/archive/13d64460cba64950aff41e230cc801225bd9a3e2.tar.gz
  nvimCmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "13d64460cba64950aff41e230cc801225bd9a3e2";
      sha256 = "091argbivsnjp3ibsnci2qj5jrr2b39gicrlz2ky41kmb4pmw36b";
    };
  };

  # nix-prefetch-url --unpack https://github.com/neovim/nvim-lspconfig/archive/ea29110765cb42e842dc8372c793a6173d89b0c4.tar.gz
  nvimLspConfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "ea29110765cb42e842dc8372c793a6173d89b0c4";
      sha256 = "1i1yjk939pxfk9dpv4rh229srx02yxklzwk051a9qprq3hjhwl6v";
    };
  };

  # nix-prefetch-url --unpack https://github.com/L3MON4D3/LuaSnip/archive/7c634ddf7ff99245ef993b5fa459c3b61e905075.tar.gz 
  luasnip = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "luasnip";
    src = pkgs.fetchFromGitHub {
      owner = "L3MON4D3";
      repo = "LuaSnip";
      rev = "7c634ddf7ff99245ef993b5fa459c3b61e905075";
      sha256 = "0s3qsl79nalkbb4fbrhbnqdcfrw4ln1ff6kajxs7lnlhkrymg3jv";
    };
  };

  # nix-prefetch-url --unpack https://github.com/saadparwaiz1/cmp_luasnip/archive/d6f837f4e8fe48eeae288e638691b91b97d1737f.tar.gz
  cmpLuasnip = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "cmp_luasnip";
    src = pkgs.fetchFromGitHub {
      owner = "saadparwaiz1";
      repo = "cmp_luasnip";
      rev = "d6f837f4e8fe48eeae288e638691b91b97d1737f";
      sha256 = "0cmfjqps7j3056y8avkrfz40kx8qcdxf4v1xvfv03nrw9xdwwh5y";
    };
  };

  neovim6Revision = import
    (builtins.fetchTarball {
      name = "nixos-unstable-2022-01-01";
      url = "https://github.com/nixos/nixpkgs/archive/9d6d1a474b946c98168bf7fee9e4185ed11cfd8f.tar.gz";
      # Hash obtained using `nix-prefetch-url --unpack <url>`
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/default.nix
      sha256 = "183q04asndwganf31q4fx0aigc20ad6ixs56m92y3d4iry70qv91";
    })
    { };
  neovim6 = neovim6Revision.neovim;

in
neovim6.override {
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
        instantNvim
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
    customRC = builtins.readFile ./../dotfiles/.vimrc;
  };
}
