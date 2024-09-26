#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &


###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
COMP_NAME="MBA"

sudo scutil --set ComputerName "$COMP_NAME"
sudo scutil --set HostName "$COMP_NAME"
sudo scutil --set LocalHostName "$COMP_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMP_NAME"


###############################################################################
# Finder                                                                    
###############################################################################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"


###############################################################################
# Trackpad                                                                    
###############################################################################

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable dragging with three fingers (accessibility)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true


###############################################################################
# Finder                                                                    
###############################################################################

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Always show folder icon before title in the title bar
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true

# Show the ~/Library folder
# chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library


###############################################################################
# Screencapture                                                                    
###############################################################################

# Change the location of screenshots
defaults write com.apple.screencapture location ~/Downloads/Screenshots

# Set format
defaults write com.apple.screencapture type -string "jpg"


###############################################################################
# Energy saving                                                               #
###############################################################################

# Time (minuntes) to turn off display when on power source
sudo pmset -a displaysleep 20

# Time (minuntes) to turn off display when on battery
sudo pmset -b displaysleep 10

# Set low power mode to 'never'
sudo pmset -a lowpowermode 0



###############################################################################
# Restart services for changes to take effect                                                                    
###############################################################################

if [ -f restart-services.sh ]; then
    source restart-services.sh
elif [ -f defaults/restart-services.sh ]; then
    source defaults/restart-services.sh
else
    echo "restart-services.sh not found"
    exit 1
fi

echo "Done. Note that some of these of macos file changes require a logout/restart to take effect."
