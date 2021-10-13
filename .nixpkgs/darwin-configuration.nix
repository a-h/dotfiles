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

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  }; 

  #neovim5Revision = import (builtins.fetchTarball {
    #name = "nixos-unstable-2021-08-18";
    #url = "https://github.com/nixos/nixpkgs/archive/51e3fe53462eb72aa038f2b47735acea8b1fcae2.tar.gz";
    ## Hash obtained using `nix-prefetch-url --unpack <url>`
    #sha256 = "018njpwyhzwxlm8l4rc80qakzgyfqq9yzmr2nimv0033rvjcvxa4";
  #}) {};
  #neovim5 = neovim5Revision.neovim;

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
      python-with-global-packages
      twet
      # Java development.
      pkgs.jdk # Development.
      pkgs.jre # Runtime.
      pkgs.gradle # Build tool.
      jdtls # Language server.
      # Other.
      pkgs.aerc
      pkgs.ag # Silver Searcher.
      pkgs.asciinema
      pkgs.astyle # Code formatter for C.
      pkgs.aws-vault
      pkgs.awslogs
      pkgs.ccls # C LSP Server.
      pkgs.cmake # Used by Raspberry Pi Pico SDK.
      pkgs.docker
      pkgs.dotnetCorePackages.sdk_3_1
      pkgs.entr # Execute command when files change.
      pkgs.fd # Find that respects .gitignore.
      pkgs.fzf # Fuzzy search.
      pkgs.gcalcli # Google Calendar CLI.
      pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC.
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.go
      pkgs.go-swagger
      pkgs.goimports
      pkgs.google-cloud-sdk
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
      pkgs.nodejs-14_x
      pkgs.pass
      pkgs.ripgrep
      pkgs.ssm-session-manager-plugin
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
	pkgs.neovim.override {
	  vimAlias = true;
	  configure = {
	    packages.myPlugins = with pkgs.vimPlugins; {
	      start = [
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
		ultisnips #SirVer/ultisnips
		vim-snippets #honza/vim-snippets
		vim-visual-multi #mg979/vim-visual-multi
		easygrep #dkprice/vim-easygrep
		nvim-lspconfig #https://neovim.io/doc/user/lsp.html#lsp-extension-example
		vimTempl
		nvim-compe
		nvim-jdtls
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
}

