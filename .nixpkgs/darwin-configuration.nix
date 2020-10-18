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

  python-with-global-packages = pkgs.python3.withPackages(ps: with ps; [
    pip
    botocore
    boto3
    numpy
  ]);

  #goreleaser = pkgs.callPackage ./goreleaser.nix {};
  goreplace = pkgs.callPackage ./goreplace.nix {};

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  }; 

in

{
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      #goreleaser
      goreplace
      nodePackages."@aws-amplify/cli"
      python-with-global-packages
      pkgs.aerc
      pkgs.asciinema
      pkgs.awscli
      pkgs.docker
      pkgs.dotnetCorePackages.sdk_3_1
      pkgs.fzf
      pkgs.gcalcli
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      pkgs.go
      pkgs.gopls
      pkgs.goimports
      pkgs.gopass
      pkgs.graphviz
      pkgs.htop
      pkgs.hugo
      pkgs.imagemagick
      pkgs.jq
      pkgs.lynx
      pkgs.nmap
      pkgs.nodejs
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript
      pkgs.nodePackages.serverless
      pkgs.nodePackages.node2nix
      pkgs.ripgrep
      pkgs.terraform
      pkgs.tmux
      pkgs.tmuxPlugins.open
      pkgs.tmuxPlugins.yank
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
		  vim-go
		  vim-lastplace
		  vim-nix
		  coc-prettier
		  coc-nvim
		  coc-tsserver # neoclide/coc-tsserver
		  coc-json
		  nerdcommenter #preservim/nerdcommenter
		  ctrlp #ctrlpvim/ctrlp.vim
		  vim-sleuth #tpope/vim-sleuth
		  vim-surround #tpope/vim-surround
		  vim-test #janko/vim-test
		  coverage #ruanyl/coverage.vim
		  ultisnips #SirVer/ultisnips
		  vim-snippets #honza/vim-snippets
		  vim-visual-multi #mg979/vim-visual-multi
		  easygrep #dkprice/vim-easygrep
		];
		opt = [];
	      };
	      customRC = builtins.readFile ./../dotfiles/.vimrc;
	  };
	}
      )
    ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Disable documentation until https://github.com/LnL7/nix-darwin/issues/217 is fixed.
  documentation.enable = false;
}

