{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "twet";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "quite";
    repo = "twet";
    rev = "v1.2.0";
    # Calculated by downloading the code and running nix-hash --type sha256 .
    sha256 = "09wg0l55pkhi04vmjlrd1dj7311f5vp57lsgdq7wzbxyaipjcna1";
  };

  vendorHash = "sha256-EkSLrb29wA+e2OoUrGMmV7y26z9RnK1tcIPkJm8UI/0=";

  meta = with lib; {
    description = "A twtxt client written in go.";
    homepage = "https://github.com/quite/twet";
    license = licenses.mit;
    maintainers = with maintainers; [ quite ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
