#!/bin/bash

test() {
	rm -rf ~/.config/nvim.bak
	rm -rf ~/.local/share/nvim.bak
	rm -rf ~/.local/state/nvim.bak
	rm -rf ~/.cache/nvim.bak

	mv ~/.config/nvim ~/.config/nvim.bak
	mv ~/.local/share/nvim ~/.local/share/nvim.bak
	mv ~/.local/state/nvim ~/.local/state/nvim.bak
	mv ~/.cache/nvim ~/.cache/nvim.bak

	mkdir -p ~/.config/nvim

	cp -r ~/development/repos/astronvim_config/* ~/.config/nvim/

	nvim
}

update() {
	rm -rf ~/.config/nvim.bak
	rm -rf ~/.local/share/nvim.bak
	rm -rf ~/.local/state/nvim.bak
	rm -rf ~/.cache/nvim.bak

	mv ~/.config/nvim ~/.config/nvim.bak
	mv ~/.local/share/nvim ~/.local/share/nvim.bak
	mv ~/.local/state/nvim ~/.local/state/nvim.bak
	mv ~/.cache/nvim ~/.cache/nvim.bak

	git clone https://github.com/curious-toast/astronvim_config.git ~/.config/nvim

	nvim
}

revert() {
	mv ~/.config/nvim.bak ~/.config/nvim
	mv ~/.local/share/nvim.bak ~/.local/share/nvim
	mv ~/.local/state/nvim.bak ~/.local/state/nvim
	mv ~/.cache/nvim.bak ~/.cache/nvim

	nvim
}

reset() {
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim

	git clone https://github.com/curious-toast/astronvim_config.git ~/.config/nvim

	nvim
}

help() {
	echo "Usage: $0 COMMAND"
	echo ""
	echo "Commands:"
	echo "  test      Backup existing Neovim configuration and install the local changes."
	echo "  update    Backup existing Neovim configuration and install the latest version."
	echo "  revert    Restore the previous Neovim configuration from backup."
	echo "  reset     Remove existing Neovim configuration and install a fresh copy."
	echo "  help      Display this help message."
	echo ""
	echo "This script manages the Neovim configuration, allowing easy updates, reverts, or resets."
}

case "$1" in
test)
	test
	;;
update)
	update
	;;
revert)
	revert
	;;
reset)
	reset
	;;
help)
	help
	;;
*)
	help
	exit 1
	;;
esac
