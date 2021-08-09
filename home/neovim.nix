{ config, lib, pkgs, unstable, home-manager, ... }:
{
 programs.neovim = {
   enable = true;
   package = with unstable.legacyPackages.${pkgs.system}; neovim-unwrapped;
   viAlias = true;
   vimAlias = true;
   extraConfig = builtins.readFile ../dotfiles/init.vim;
   plugins = with pkgs.vimPlugins; [
     vim-airline
     vim-fugitive
     vim-nix
     fzf-vim
     nvim-treesitter
     nvim-lspconfig
   ];
 };
}
