{ pkgs, unstable, ... }:
{
  home.packages = [
    pkgs.clang-tools # clangd included
    pkgs.cmake-language-server
    pkgs.elixir_ls
    pkgs.rebar3 # dependency of elixir_ls
    pkgs.pyright
    pkgs.rnix-lsp
    pkgs.solargraph
    pkgs.terraform-ls
    pkgs.sumneko-lua-language-server
    pkgs.yaml-language-server
  ];
}
