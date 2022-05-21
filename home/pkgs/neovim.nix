{ config, lib, pkgs, unstable, home-manager, ... }:
{
 programs.neovim = {
   enable = true;
   package = with unstable.legacyPackages.${pkgs.system}; neovim-unwrapped;
   viAlias = true;
   vimAlias = true;
   extraConfig = builtins.readFile ../../dotfiles/neovim/init.vim;
   plugins = with pkgs.vimPlugins; [
     vim-airline
     vim-fugitive
     vim-nix
     fzf-vim
     nvim-treesitter
     nvim-lspconfig
     vim-terraform
     vim-elixir
     comment-nvim
     unstable.legacyPackages.${pkgs.system}.vimPlugins.which-key-nvim # need unstable due to https://github.com/folke/which-key.nvim/pull/227
   ];
 };
}
