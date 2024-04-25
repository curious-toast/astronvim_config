#!/bin/bash

# Function to check for dependencies
dep_ch() {
	for dep; do
		if ! command -v "$dep" >/dev/null; then
			terminate_script "Program \"$dep\" not found. Please install it."
		fi
	done
}

# Display error message in red to stderr
error() {
	printf "\33[2k\r\033[1;31m%s\033[0m\n" "$*" >&2
}

# Display an informational message (first argument in green, second in magenta)
inf() {
	printf "\33[2K\r\033[1;32m%s \033[1;35m%s\033[0m\n" "$1" "$2"
}

# Function to terminate script if error occur
terminate_script() {
	error "$*"
	exit 1
}

# Check and install font-hack-nerd-font if not already installed
if ! fc-list | grep -qi "Hack Nerd Font"; then
	inf "Installing font-hack-nerd-font..."
	brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
else
	inf "font-hack-nerd-font is already installed."
fi

# Provide dependencies (space separated)
dep_ch "gcc" "cmake" "rg" "lazygit" "python3" "node" || true
