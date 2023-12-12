{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "goreplace";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "piranha";
    repo = "goreplace";
    rev = "2.6";
    sha256 = "sha256-fh1y0fYW1LLQb/xMnSB2MFpPcZ0pKx8MIGWsTT5D5mg=";
  };

  vendorHash = "sha256-ThrzTgAjf/YshMaoFahJn7bdTR6GXzp/urJo68NsTFo=";

  meta = with lib; {
    description = "Replace in files.";
    homepage = "https://github.com/piranha/goreplace";
    license = licenses.isc;
    maintainers = with maintainers; [ piranha ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
