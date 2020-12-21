# Copy config into operating system.
# This includes the ~/.config/nixpkgs/home.nix that configures the system.
cp -r ./home /home
cp -r ./etc /etc

# Rebuild NixOS.
nixos-rebuild switch
