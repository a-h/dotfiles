{ lib, git, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "d2";
  version = "v0.1.5";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    rev = "v0.1.5";
    sha256 = "sha256-z7R3lseEPWtBl5wjpMK8okQG31L1k2R/+B9M25TrI6s=";
  };

  vendorSha256 = "sha256-t94xCNteYRpbV2GzrD4ppD8xfUV1HTJPkipEzr36CaM=";

  # Disable the check, until https://github.com/terrastruct/d2/issues/678 is fixed.
  # I don't want to use a specific Go version for this package.
  checkPhase = "";

  meta = with lib; {
    description = "Diagrams from text";
    homepage = https://github.com/terrastruct/d2;
    license = licenses.mpl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
