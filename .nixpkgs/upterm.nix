{ stdenv, go, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "upterm";
  version = "v0.9.0";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v0.9.0";
    sha256 = "ywwqX4aw9vc2kptYZisArTpdz7Cf49Z0jMdP90KXejs=";
  };

  nativeBuildInputs = [ go ];
  builder = ./upterm-install.sh;
  system = builtins.currentSystem;
}
