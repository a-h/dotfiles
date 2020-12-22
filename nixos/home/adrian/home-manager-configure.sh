# Add home manager.
# Follow the stable channel.
nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
# Uncomment to follow the unstable channel.
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# Install.
nix-channel --update
nix-shell '<home-manager>' -A install

# Copy configuration.
cp -r ./ ~/adrian

# Run it.
home-manager switch 
