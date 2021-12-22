{ pkgs, ... }:
{
  home.packages = [
    # dev-tools
    pkgs.aws-vault
    pkgs.awscli
    pkgs.coz
    pkgs.dconf2nix # syntax converter: dconf -> home manager
    pkgs.docker
    pkgs.gdb
    pkgs.kubectl
    pkgs.postgresql
    pkgs.ranger
    pkgs.ripgrep
    pkgs.tig
    pkgs.valgrind
    pkgs.vscode
    pkgs.zsh
    pkgs.arp-scan
    pkgs.go-jira
    pkgs.google-cloud-sdk
    pkgs.jq
    pkgs.xclip

    # Language servers
    pkgs.clang-tools # clangd included
    pkgs.cmake-language-server
    pkgs.elixir_ls
    pkgs.pyright
    pkgs.rnix-lsp
    pkgs.solargraph
    pkgs.terraform-ls

    # build tools
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake

    # media
    pkgs.gimp
    pkgs.peek
    pkgs.spotify
    pkgs.vlc
    pkgs.mixxx

    # Local packages (unpublished)
    (pkgs.callPackage pkgs/webex {})

    # web
    pkgs.chromium
    pkgs.element-desktop
    pkgs.slack

    # tooling
    pkgs.wineWowPackages.stable # 32- and 64-bit
  ];

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };
}
