{ stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "7af054e5088b68c24b3d6e135e5ca8d91bbd5a05cb7f7f0187367b3e6e9e05ee";
    darwin-arm64 = "fd9cfb5dd6c75a347cfc641a253f0db1cebaca16b0dd37965351c6184ba595e4";
    linux-amd64 = "dea9ca38a0b852a74e81c26134671af7c0fbe65d81b0dc1c5bfe22cf7d4c8858";
    linux-arm64 = "c3fa6d16ffa261091a5617145553c71d21435ce547e44cc6dfb7470865527cc7";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.24.0";

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
