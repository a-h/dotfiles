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

  vimQuicktemplate = pkgs.vimUtils.buildVimPlugin {
    name = "quicktemplate.vim";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "quicktemplate.vim";
      rev = "c2aed012c0de37303509e93d3010524a361a7795";
      sha256 = "1lgjj01cifvkqgikr976b45j9cdhrc28wzhr7bshf400g1fwfdim";
    };
  };

  vimTempl = pkgs.vimUtils.buildVimPlugin {
    name = "templ.vim";
    src = pkgs.fetchFromGitHub {
      owner = "Joe-Davidson1802";
      repo = "templ.vim";
      rev = "53685e70d040e311cb0fe6e4a5a02db958bb55ba";
      sha256 = "1bi4yczxgg12ir3pisshhc35jfcyilljdxw1g46w1f76pvg8015v";
    };
  };

  python-with-global-packages = pkgs.python3.withPackages(ps: with ps; [
    pip
    botocore
    boto3
    numpy
  ]);

  awsSamCli = pkgs.callPackage ./aws-sam-cli.nix {};
  #goreleaser = pkgs.callPackage ./goreleaser.nix {};
  goreplace = pkgs.callPackage ./goreplace.nix {};
  twet = pkgs.callPackage ./twet.nix {};

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  }; 

in

{
  nixpkgs.config.allowUnfree = true;
  environment.variables = { EDITOR = "vim"; };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      #goreleaser
      goreplace
      twet
      nodePackages."@aws-amplify/cli"
      #awsSamCli
      python-with-global-packages
      pkgs.ag
      pkgs.awslogs
      pkgs.aerc
      pkgs.asciinema
      pkgs.awscli2
      pkgs.ssm-session-manager-plugin
      pkgs.aws-vault
      pkgs.docker
      pkgs.dotnetCorePackages.sdk_3_1
      pkgs.entr
      pkgs.fzf
      pkgs.gcalcli
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.go
      pkgs.gopls
      pkgs.goimports
      pkgs.graphviz
      pkgs.htop
      pkgs.hugo
      pkgs.imagemagick
      pkgs.jq
      pkgs.lynx
      pkgs.mutt
      pkgs.nmap
      pkgs.nodejs
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript
      pkgs.nodePackages.node2nix
      pkgs.pass
      pkgs.ripgrep
      pkgs.terraform
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
		vim-go
		vim-lastplace
		vim-nix
		coc-prettier
		coc-nvim
		coc-tsserver # neoclide/coc-tsserver
		vim-jsx-typescript
		vim-graphql
		coc-json
		nerdcommenter #preservim/nerdcommenter
		vim-sleuth #tpope/vim-sleuth
		vim-surround #tpope/vim-surround
		vim-test #janko/vim-test
		coverage #ruanyl/coverage.vim
		ultisnips #SirVer/ultisnips
		vim-snippets #honza/vim-snippets
		vim-visual-multi #mg979/vim-visual-multi
		easygrep #dkprice/vim-easygrep
		# requires nvim 5
		#nvim-lspconfig #https://neovim.io/doc/user/lsp.html#lsp-extension-example
		vimTempl
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

