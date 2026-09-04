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

upgrade() {
	# Refresh scaffolding from the latest AstroNvim template, preserving your
	# user.lua and community.lua. This bumps the version pin (it lives in the
	# template's lazy_setup.lua) but does NOT adapt your config to breaking
	# changes -- you review and test that yourself.
	local tmp
	tmp="$(mktemp -d)"
	echo "Cloning latest AstroNvim template..."
	git clone --depth 1 https://github.com/AstroNvim/template "$tmp"
	# Scaffolding only. Never touch user.lua or community.lua.
	cp "$tmp/init.lua" "$REPO/init.lua"
	cp "$tmp/lua/lazy_setup.lua" "$REPO/lua/lazy_setup.lua"
	cp "$tmp/lua/polish.lua" "$REPO/lua/polish.lua"
	cp "$tmp/lua/plugins/astrocore.lua" "$REPO/lua/plugins/astrocore.lua"
	cp "$tmp/lua/plugins/astroui.lua" "$REPO/lua/plugins/astroui.lua"
	rm -rf "$tmp"
	echo ""
	echo "Scaffolding refreshed. user.lua and community.lua are untouched."
	echo "New version pin:"
	grep -m1 'version =' "$REPO/lua/lazy_setup.lua"
	echo ""
	echo "Next steps:"
	echo "  1. Branch it:    git -C $REPO checkout -b upgrade"
	echo "  2. Read the release notes for breaking changes:"
	echo "     https://github.com/AstroNvim/AstroNvim/releases"
	echo "  3. Check the new Neovim minimum (brew upgrade neovim)."
	echo "  4. Adapt lua/plugins/user.lua to any breaking changes."
	echo "  5. Fresh install and test:   $0 clean && nvim"
	echo "  6. Merge when happy:         git -C $REPO checkout main && git merge upgrade"
}

help() {
	echo "Usage: $0 COMMAND"
	echo ""
	echo "Commands:"
	echo "  link     Create or repair the ~/.config/nvim -> repo symlink."
	echo "  clean    Remove plugin data, state, and cache. Keeps the symlink."
	echo "  reset    Clean, then start nvim for a fresh plugin install."
	echo "  upgrade  Refresh scaffolding from the latest AstroNvim template."
	echo "  help     Show this message."
	echo ""
	echo "The config lives in this repo and is symlinked to ~/.config/nvim."
	echo "Edit files here; changes are live. Use ':Lazy update' for plugin updates."
}

case "${1:-help}" in
link) link ;;
clean) clean ;;
reset) reset ;;
upgrade) upgrade ;;
help) help ;;
*)
	help
	exit 1
	;;
esac
