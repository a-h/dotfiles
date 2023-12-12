{ stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "a2e1d5743e896e5fe1e7d96479c0a769254aed18cf216cf8f4c3a2300a9b3923";
    darwin-arm64 = "d0f8ac0c4fb3efc223a833010901d02954e3923cfe2c9a2ff0e4254a777cc9cc";
    linux-amd64 = "e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e";
    linux-arm64 = "841cced7ecda9b2014f139f5bab5ae31785f35399f236b8b3e75dff2a2978d96";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.21.5";

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
