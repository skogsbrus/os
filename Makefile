.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild switch --use-remote-sudo --flake .

rb-test:
	sudo nixos-rebuild test --use-remote-sudo --flake .

rb-boot:
	sudo nixos-rebuild boot --use-remote-sudo --flake .

.PHONY: install
install:
	ln -T -fs $(PWD)/dotfiles/git/gitconfig ~/.gitconfig
