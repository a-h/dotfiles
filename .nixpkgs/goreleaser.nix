{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.140.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "goreleaser";
    rev = "v${version}";
    # Calculated by downloading the code and running nix-hash --type sha256 .
    sha256 = "d16940ccd1a62a1d5c12ef6434da260197dc04269dc64cad468ee51289327fd0";
  };

  vendorSha256 = "0bsqzjj7k8d84s5gakd1f66li2n9c1is85jw6rb7832c079h1d04";

  meta = with lib; {
    description = "Release Go projects easily.";
    homepage = https://github.com/goreleaser/goreleaserr;
    license = licenses.mit;
    maintainers = with maintainers; [ goreleaser ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
