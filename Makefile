UNAME := $(shell uname)

rb-switch:
ifeq ($(UNAME), Darwin)
	echo "Switching configuration on $(UNAME)" 
	darwin-rebuild switch --flake .
else
	echo "Switching configuration on $(UNAME)" 
	sudo nixos-rebuild switch --use-remote-sudo --flake .
endif
rb-test:
ifeq ($(UNAME), Linux)
	sudo nixos-rebuild test --use-remote-sudo --flake .
else
	echo "Unsupported system $(UNAME)"
endif

rb-boot:
ifeq ($(UNAME), Linux)
	sudo nixos-rebuild boot --use-remote-sudo --flake .
else
	echo "Unsupported system $(UNAME)"
endif

install:
	ln -fs $(PWD)/dotfiles/git/gitconfig ~/.gitconfig

mac-update-zshrc:
	echo 'if test -e /etc/static/zshrc; then . /etc/static/zshrc; fi' | sudo tee -a /etc/zshrc

.PHONY: rb-switch rb-test rb-boot install mac-update-zshrc
