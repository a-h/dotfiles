{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.148";

  src = fetchFromGitHub {
    owner = "Joe-Davidson1802";
    repo = "xc";
    rev = "v0.0.148";
    sha256 = "sha256-aWtl/ItO/0hPssfkE9o+DX0iFoHXwo2ouCaEfbtx+Nw=";
  };

  vendorSha256 = "sha256-14dtguu787VR8/sYA+9WaS6xr/dB6ZcUjOzDEkFDpH4=";

  meta = with lib; {
    description = "eXeCute project tasks from a readme file";
    homepage = https://github.com/Joe-Davidson1802/xc;
    license = licenses.mit;
    maintainers = with maintainers; [ Joe-Davidson1802 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
