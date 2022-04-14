.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild switch --flake .

rb-test:
	sudo nixos-rebuild test --flake .

rb-boot:
	sudo nixos-rebuild boot --flake .

.PHONY: install
install:
	ln -T -fs $(PWD)/dotfiles/git/gitconfig ~/.gitconfig
