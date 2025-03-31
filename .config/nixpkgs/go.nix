{ stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "addbfce2056744962e2d7436313ab93486660cf7a2e066d171b9d6f2da7c7abe";
    darwin-arm64 = "295581b5619acc92f5106e5bcb05c51869337eb19742fdfa6c8346c18e78ff88";
    linux-amd64 = "cb2396bae64183cdccf81a9a6df0aea3bce9511fc21469fb89a0c00470088073";
    linux-arm64 = "8df5750ffc0281017fb6070fba450f5d22b600a02081dceef47966ffaf36a3af";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.24.1";

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
