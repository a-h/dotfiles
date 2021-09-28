{ pkgs, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "pact";
  version = "1.88.69";
  src = fetchurl {
    url = "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.88.69/pact-1.88.69-osx.tar.gz";
    sha256 = "0xv2y680xsjav6b9bbvcn9bcc2iy0dllxif92mzznh4fv9rdrjgj";
  };
  builder = ./pact-install.sh;
  system = builtins.currentSystem;
}

