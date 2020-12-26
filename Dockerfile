FROM nixos/nix

RUN nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
RUN nix-channel --update
RUN nix-shell '<home-manager>' -A install
COPY ./nixos/home/adrian /root
RUN home-manager switch
