{ stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "95d9933cdcf45f211243c42c7705c37353cccd99f27eb4d8e2d1bf2f4165cb50";
    darwin-arm64 = "4cd1bcb05be03cecb77bccd765785d5ff69d79adf4dd49790471d00c06b41133";
    linux-amd64 = "904b924d435eaea086515bc63235b192ea441bd8c9b198c507e85009e6e4c7f0";
    linux-arm64 = "8d21325bfcf431be3660527c1a39d3d9ad71535fabdf5041c826e44e31642b5a";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.22.5";

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
