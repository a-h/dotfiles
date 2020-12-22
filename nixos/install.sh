# Copy config into operating system.
# This includes the ~/.config/nixpkgs/home.nix that configures the system.
cp -r ./etc /etc

# Rebuild NixOS.
nixos-rebuild switch

# Enable SSH login for adrian.
cp -r ./home/adrian/.ssh /home/adrian/.ssh
chown -R adrian:users ./home/adrian/.ssh
