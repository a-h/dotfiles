{ pkgs, stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "16f8047d7b627699b3773680098fbaf7cc962b7db02b3e02726f78c4db26dfde";
    darwin-arm64 = "35d819df25197c0be45f36ce849b994bba3b0559b76d4538b910d28f6395c00d";
    linux-386 = "ba8c97965e0856c69c9ca2c86f96bec5bb21de43e6533e25494bb211d85cda1b";
    linux-amd64 = "5e8c5a74fe6470dd7e055a461acda8bb4050ead8c2df70f227e3ff7d8eb7eeb6";
    linux-arm64 = "b62a8d9654436c67c14a0c91e931d50440541f09eb991a987536cb982903126d";
    linux-armv6l = "f3ccec7816ecd704ebafd130b08b8ad97c55402a8193a107b63e9de12ab90118";
    linux-ppc64le = "37e1d4342f7103aeb9babeabe8c71ef3dba23db28db525071119e94b2aa21d7d";
    linux-s390x = "51b45dec41295215df17f78e67d1a373b9dda97a5e539bed440974da5ffc97de";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.19.2";

  toGoPlatform = platform: "${toGoKernel platform}-${toGoCPU platform}";

  platform = toGoPlatform stdenv.hostPlatform;
in
stdenv.mkDerivation {
  pname = "go";
  version = version;
  src = fetchurl {
    url = "https://golang.org/dl/go${version}.${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "Missing Go bootstrap hash for platform ${platform}");
  };
  builder = ./go-install.sh;
  system = builtins.currentSystem;
}
