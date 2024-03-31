{ config
, lib
, pkgs
, ...
}:
let
    cfg = config.skogsbrus.lspServers;
    inherit (lib) mkEnableOption mkIf;
in
{
  options.skogsbrus.lspServers = {
    enable = mkEnableOption "LSP servers";
    enableAll = mkEnableOption "installation of everything this module has to offer";
    cxx = mkEnableOption "C/C++";
    elixir = mkEnableOption "elixir";
    python = mkEnableOption "python";
    ruby = mkEnableOption "ruby";
    rust = mkEnableOption "rust";
    terraform = mkEnableOption "terraform";
  };

  config = with pkgs; mkIf cfg.enable {
    home.packages = [
      #rnix-lsp # Disabled due to nix dependency being insecure
      luaPackages.lua-lsp
      yaml-language-server
    ]
    ++ (if cfg.enableAll || cfg.cxx then [
      clang-tools # clangd included
      cmake-language-server
    ] else [ ])
    ++ (if cfg.enableAll || cfg.terraform then [
      terraform-ls
    ] else [ ])
    ++ (if cfg.enableAll || cfg.elixir then [
      elixir_ls
      rebar3
    ] else [ ])
    ++ (if cfg.enableAll || cfg.python then [
      pyright
    ] else [ ])
    ++ (if cfg.enableAll || cfg.ruby then [
      solargraph
    ] else [ ])
    ++ (if cfg.enableAll || cfg.rust then [
      rust-analyzer
    ] else [ ]);
  };
}
