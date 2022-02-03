chown -R root:nixbld /nix
chmod 1777 /nix/var/nix/profiles/per-user
chown -R $USER:staff /nix/var/nix/profiles/per-user/$USER
mkdir -m 1777 -p /nix/var/nix/gcroots/per-user
chown -R $USER:staff /nix/var/nix/gcroots/per-user/$USER
