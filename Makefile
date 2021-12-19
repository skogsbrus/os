.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild switch --flake .

.PHONY: install
install:
	ln -T -fs $(PWD)/dotfiles/git/gitconfig ~/.gitconfig
	ln -T -fs $(PWD)/dotfiles/neovim ~/.config/nvim
