{ pkgs, ... }:
{
  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix
    ./lsp.nix
  ];
}
