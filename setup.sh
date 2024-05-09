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

# Check for and install Pandoc if not already installed
if ! command -v pandoc >/dev/null; then
	inf "Installing Pandoc..."
	brew install pandoc
else
	inf "Pandoc is already installed."
fi

# Check for and install MacTeX if not already installed
if ! command -v pdflatex >/dev/null; then
	inf "Installing MacTeX. This may take a while..."
	brew install mactex

	# Add MacTeX to PATH
	echo "Adding MacTeX to PATH..."
	TEX_PATH="/Library/TeX/texbin"
	echo "export PATH=$TEX_PATH:\$PATH" >>~/.zshrc
	source ~/.zshrc

	inf "MacTeX installation completed."
else
	inf "MacTeX is already installed."
fi

# Validate LaTeX installation
if command -v pdflatex >/dev/null; then
	inf "Validation" "pdflatex is successfully installed and found in PATH."
else
	terminate_script "Failed to verify pdflatex installation. Check your installation and PATH."
fi

# Provide dependencies (space separated)
dep_ch "gcc" "cmake" "rg" "lazygit" "python3" "node" "pandoc" "pdflatex" || true
