#!/bin/bash
# AstroNvim config manager.
#
# The config lives in THIS repo and is symlinked to ~/.config/nvim, so edits
# here are live. There is no deploy step. Use ":Lazy update" inside nvim for
# plugin updates.

set -euo pipefail

REPO="$HOME/development/repos/astronvim_config"
CONFIG="$HOME/.config/nvim"

link() {
	# Create or repair the ~/.config/nvim -> repo symlink.
	if [ -L "$CONFIG" ]; then
		rm "$CONFIG"
	elif [ -e "$CONFIG" ]; then
		mv "$CONFIG" "$CONFIG.bak.$(date +%s)"
		echo "Moved existing config dir to a .bak dir."
	fi
	ln -s "$REPO" "$CONFIG"
	echo "Linked $CONFIG -> $REPO"
}

clean() {
	# Remove plugin data, state, and cache. Keeps the config symlink.
	rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
	echo "Cleared nvim data, state, and cache. Next launch reinstalls plugins."
}

reset() {
	# Full clean reinstall, then start nvim.
	clean
	nvim
}

help() {
	echo "Usage: $0 COMMAND"
	echo ""
	echo "Commands:"
	echo "  link    Create or repair the ~/.config/nvim -> repo symlink."
	echo "  clean   Remove plugin data, state, and cache. Keeps the symlink."
	echo "  reset   Clean, then start nvim for a fresh plugin install."
	echo "  help    Show this message."
	echo ""
	echo "The config lives in this repo and is symlinked to ~/.config/nvim."
	echo "Edit files here; changes are live. Use ':Lazy update' for plugin updates."
}

case "${1:-help}" in
link) link ;;
clean) clean ;;
reset) reset ;;
help) help ;;
*)
	help
	exit 1
	;;
esac
