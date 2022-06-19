{ pkgs, ... }:
{
  imports = [
    ./core.nix
    ./dev.nix
    ./client.nix
    ./lsp.nix
  ];
}
