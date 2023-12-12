{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "adr-tools";
  version = "3.0.0";
  src = fetchurl {
    url = "https://github.com/npryce/adr-tools/archive/refs/tags/3.0.0.tar.gz";
    sha256 = "0z2x6af3p0w8hjh0k8vh9698zgzw5qsxcgii2d0kq9bw8ldg744l";
  };
  builder = ./adr-tools-install.sh;
  system = builtins.currentSystem;
}
