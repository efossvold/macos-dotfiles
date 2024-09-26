#!/usr/bin/env fish
echo "Installing fish theme and extensions 🎨"

# Check for fish and install if we don't have it
if test ! $(which fish)
    brew install fish
end

# Add fish to allowed shells
if test -z $(grep "/opt/homebrew/bin/fish" /etc/shells)
    echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
end

# Set fish as default shell
chsh -s /opt/homebrew/bin/fish

# # fisher (fish shell plugin manager)
# # https://github.com/jorgebucaran/fisher
# curl -sL https://git.io/fisher | source

# # fish theme
# fisher install dracula/fish

# # fish-nvm (node manager)
# # https://github.com/jorgebucaran/fish-nvm
# fisher install jorgebucaran/nvm.fish
