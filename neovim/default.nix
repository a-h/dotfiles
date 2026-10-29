{ pkgs, lib, go ? pkgs.go, gopls ? pkgs.gopls, ... }:

let
  wrappedNeovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      blink-cmp
      fzf-lua
      nvim-lspconfig
      nvim-tree-lua
    ];
    luaRcContent = builtins.readFile ./init.lua;
    wrapRc = true;
    viAlias = true;
    vimAlias = true;
  };

  # Runtime dependencies are baked into the nvim binary's PATH so that the
  # editor is self-contained and does not rely on system-installed packages.
  # The Go toolchain and gopls are passed in via the go and gopls arguments
  # (defaulting to pkgs.go and pkgs.gopls) so the caller can supply newer
  # versions than the stable nixpkgs ones, keeping pace with new Go releases.
  runtimeDeps = [
    go
    gopls
    pkgs.gotools
  ] ++ (with pkgs; [
    nixd
    nixfmt
    fzf
    ripgrep
    ccls
    templ
    lua-language-server
    tailwindcss-language-server
    terraform-ls
    superhtml
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    rust-analyzer
    rustfmt
  ]) ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    # Clipboard providers for the editor. Linux only: macOS uses pbcopy/pbpaste,
    # and wl-clipboard does not build on Darwin.
    wl-clipboard
    xclip
  ]);
in
pkgs.symlinkJoin {
  name = "neovim";
  paths = [ wrappedNeovim ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set NVIM_APPNAME nvim-nix
  '';
  meta.mainProgram = "nvim";
}
