#!/bin/zsh

echo "Setting up your Mac... 🛠️"

## Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## Define a function which rename a `target` file to `target.backup` if the file
## exists and if it's a 'real' file, ie not a symlink
backup() {
    target=$1
    if [ -e "$target" ]; then
        if [ ! -L "$target" ]; then
            mv "$target" "$target.backup"
            echo "Backup: $target -> $target.backup"
        fi
    fi
}

symlink() {
    file=$1
    link=$2

    if [ ! -e $file ]; then
        echo "Cannot symlink $file to $link. Source not found."
    fi

    # Link already exists, overwrite
    if [ -L $link ]; then
        echo "Symlink: $file -> $link (overwrite)"
        ln -sf $file $link
    else
        # Backup existing target
        if [ -e $link ]; then
            backup $link
        fi

        echo "Symlink: $file -> $link"
        ln -s $file $link
    fi
}

###############################################################################
# Homebrew
###############################################################################

# Update recipes
brew update

## Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

###############################################################################
# Fish
###############################################################################

# fish shell
fish fish.sh

###############################################################################
# Unison
###############################################################################

# Create config dir
mkdir -p ~/.unison/cache

# Add default profile
symlink $PWD/unison/profile.prf ~/.unison/profile.prf

# Sync files
chmod +x unison/restore.sh
unison/restore.sh

# Start sync daemon
launchctl start /Users/erikfossvold/Library/LaunchAgents/com.unison.plist

###############################################################################
# .local/bin
###############################################################################

# Make scripts executable
chmod +x ~/.local/bin/*

###############################################################################
# defaults
###############################################################################

chmod +x defaults/macos.sh
defaults/macos.sh

echo "👌 Everything done!"
