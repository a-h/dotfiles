{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.27.3";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    # Calculated by downloading the code and running nix-hash --type sha256 .
    sha256 = "04xdgimbkg7kkngpfkxm7v0i3fbv3xfzvc96lafs05pn58zxrva0";
  };

  vendorSha256 = "1gnlx9rzp6vzjl7vivianhkr1c615iwvng2gfpsp6nz2b1821c07";

  meta = with lib; {
    description = "Yet another live-reloading command line utility for Go applications in development";
    homepage = https://github.com/cosmtrek/air;
    license = licenses.mit;
    maintainers = with maintainers; [ cosmtrek ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

