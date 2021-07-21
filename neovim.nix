{ config, lib, pkgs, home-manager, ... }:
{
 programs.neovim = {
   enable = true;
   viAlias = true;
   vimAlias = true;
   extraConfig = builtins.readFile ./init.vim;
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
