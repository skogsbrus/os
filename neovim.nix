{ config, lib, pkgs, ... }:
{
  home-manager.users.johanan = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set nocompatible
        set number relativenumber
	let mapleader = " "
	" Tabs
	map <leader>t :tab new<CR>
	" Fzf
	map <leader>f :Files<CR>
	map <leader>b :Buffers<CR>
	map <leader>r :Rg<CR>
	" Tabs vs spaces
	set tabstop=4 " show existing tab with 4 spaces width
        set shiftwidth=4 " when indenting with '>', use 4 spaces width
        set expandtab " On pressing tab, insert 4 spaces
      '';
      plugins = with pkgs.vimPlugins;
        [
	  vim-airline
	  vim-fugitive
	  fzf-vim
        ];
    };
  };
}
