{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "twet";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "quite";
    repo = "twet";
    rev = "v1.2.0";
    # Calculated by downloading the code and running nix-hash --type sha256 .
    sha256 = "09wg0l55pkhi04vmjlrd1dj7311f5vp57lsgdq7wzbxyaipjcna1";
  };

  vendorSha256 = "1z932ipjdr43f1nsv72i7zmvdg2p4risq57av2g0zh5xpnnqni0j";

  meta = with lib; {
    description = "A twtxt client written in go.";
    homepage = https://github.com/quite/twet;
    license = licenses.mit;
    maintainers = with maintainers; [ quite ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
