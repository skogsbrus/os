.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild switch --flake .

.PHONY: install
install:
	ln -s $(pwd)/dotfiles/gitconfig ~/.gitconfig
