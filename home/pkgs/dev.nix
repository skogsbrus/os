{ pkgs, unstable, ... }:
{
  home.packages = [
    # dev programs
    pkgs.aws-vault
    pkgs.awscli
    pkgs.go-jira
    pkgs.google-cloud-sdk
    pkgs.jetbrains-mono
    pkgs.kubectl
    pkgs.cudnn_cudatoolkit_11
    pkgs.vscode

    # dev services
    pkgs.docker
    pkgs.postgresql
    # Cleaner way to do this?
    unstable.legacyPackages.${pkgs.system}.terraform
    unstable.legacyPackages.${pkgs.system}.tflint

    # build tools
    pkgs.cmake
    pkgs.coz
    pkgs.gcc
    pkgs.gdb
    pkgs.gnumake
    pkgs.valgrind
    pkgs.wineWowPackages.stable # 32- and 64-bit
  ];
}
