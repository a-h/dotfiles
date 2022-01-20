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

  lspSignatureNvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "lsp_signature.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "a4ea841be9014b73a31376ad78d97f41432e002a";
      sha256 = "0m5jzi5hczm1z67djk1rv408jzy48rpdf4n8p5z2flmz1xd39mzx";
    };
  };

  python-with-global-packages = pkgs.python3.withPackages(ps: with ps; [
    pip
    botocore
    boto3
    numpy
  ]);

  #goreleaser = pkgs.callPackage ./goreleaser.nix {};
  adr-tools = pkgs.callPackage ./adr-tools.nix {};
  goreplace = pkgs.callPackage ./goreplace.nix {};
  html2text = pkgs.callPackage ./html2text.nix {};
  air = pkgs.callPackage ./air.nix {};
  twet = pkgs.callPackage ./twet.nix {};
  pact = pkgs.callPackage ./pact.nix {};
  jdtls = pkgs.callPackage ./jdtls.nix {};
  xc = pkgs.callPackage ./xc.nix {};
  go = pkgs.callPackage ./go.nix {};

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  }; 

  neovim6Revision = import (builtins.fetchTarball {
    name = "nixos-unstable-2021-12-05";
    url = "https://github.com/nixos/nixpkgs/archive/8ae277122450529fb973a364f3527f3ef2ca7999.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0g1i2sp80f71xncvcjhdv2xz8phn88hzymwscqljfwq8wvpw75yk";
  }) {};
  neovim6 = neovim6Revision.neovim;

  awscli_v2_2_14 = import (builtins.fetchTarball {
    name = "awscli_v2_2_14";
    url = "https://github.com/nixos/nixpkgs/archive/aab3c48aef2260867272bf6797a980e32ccedbe0.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0mhihlpmizn7dhcd8pjj9wvb13fxgx4qqr24qgq79w1rhxzzk6mv";
  }) {};
  awscli2 = awscli_v2_2_14.awscli2;

in

{
  nixpkgs.config.allowUnfree = true;
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      adr-tools
      air # Hot reload for Go.
      awscli2
      goreplace
      pact
      # python-with-global-packages # No Darwin ARM support.
      twet
      xc # Task executor.
      # Java development.
      pkgs.jdk # Development.
      pkgs.openjdk17 # Development.
      pkgs.jre # Runtime.
      pkgs.gradle # Build tool.
      jdtls # Language server.
      pkgs.maven
      # Other.
      pkgs.aerc
      pkgs.ag # Silver Searcher.
      pkgs.asciinema
      pkgs.astyle # Code formatter for C.
      pkgs.aws-vault
      pkgs.awslogs
      pkgs.ccls # C LSP Server.
      pkgs.cmake # Used by Raspberry Pi Pico SDK.
      # pkgs.dotnet-sdk # No Darwin ARM support.
      pkgs.entr # Execute command when files change.
      pkgs.fd # Find that respects .gitignore.
      pkgs.fzf # Fuzzy search.
      # pkgs.gcalcli # Google Calendar CLI.
      # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      go
      pkgs.go-swagger
      pkgs.goimports
      # pkgs.google-cloud-sdk # No Darwin ARM support.
      pkgs.gopls
      pkgs.goreleaser
      pkgs.graphviz
      pkgs.html2text
      pkgs.htop
      pkgs.hugo
      pkgs.ibm-plex
      pkgs.imagemagick
      pkgs.jq
      pkgs.lima # Alternative to Docker desktop https://github.com/lima-vm/lima
      pkgs.llvm # Used by Raspberry Pi Pico SDK.
      pkgs.lynx
      pkgs.minicom # Serial monitor.
      pkgs.mutt
      pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
      pkgs.nmap
      pkgs.nodePackages.node2nix
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodejs-16_x
      pkgs.pass
      pkgs.ripgrep
      # pkgs.ssm-session-manager-plugin # No Darwin ARM support. 
      pkgs.terraform
      pkgs.tmate
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.urlscan
      pkgs.wget
      pkgs.yarn
      pkgs.zip
      (
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
		nvim-lspconfig #https://neovim.io/doc/user/lsp.html#lsp-extension-example
		nvim-cmp
		cmp-nvim-lsp
		cmp_luasnip
		luasnip
		# Add signature to autocomplete.
		lspSignatureNvim
		# Go coverage needs treesitter.
		nvim-treesitter #github.com/nvim-treesitter/nvim-treesitter
		nvimGoCoverage #rafaelsq/nvim-goc.lua
	      ];
	      opt = [];
	    };
	    customRC = builtins.readFile ./../dotfiles/.vimrc;
	  };
	}
      )
    ];

  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
}

