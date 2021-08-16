.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild switch --flake .

.PHONY: install
install:
	ln -s $(PWD)/dotfiles/git/gitconfig ~/.gitconfig
