.PHONY: rb-switch
rb-switch:
	sudo nixos-rebuild --use-remote-sudo switch --flake .

rb-test:
	sudo nixos-rebuild --use-remote-sudo test --flake .

rb-boot:
	sudo nixos-rebuild --use-remote-sudo boot --flake .

.PHONY: install
install:
	ln -T -fs $(PWD)/dotfiles/git/gitconfig ~/.gitconfig
