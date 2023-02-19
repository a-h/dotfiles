{ lib, stdenv, go, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "xc";
  version = "v0.0.154";

  src = fetchFromGitHub {
    owner = "Joe-Davidson1802";
    repo = "xc";
    rev = "v0.0.154";
    sha256 = "GJBSPO0PffGdGAHofd1crEFXJi2xqgd8Vk2/g4ff+E4=";
  };

  nativeBuildInputs = [ go ];
  builder = ./xc-install.sh;
  system = builtins.currentSystem;

  meta = with lib; {
    description = "eXeCute project tasks from a readme file";
    homepage = https://github.com/Joe-Davidson1802/xc;
    license = licenses.mit;
    maintainers = with maintainers; [ Joe-Davidson1802 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
