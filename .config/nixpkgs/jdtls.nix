{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "jdtls";
  version = "1.4.0";
  src = fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/1.4.0/jdt-language-server-1.4.0-202109161824.tar.gz";
    sha256 = "1j6n3w927xxgsklh2243bml3icswvqy75n8w25wjv19h5vlrzwzk";
  };
  builder = ./jdtls.sh;
  system = builtins.currentSystem;
}
