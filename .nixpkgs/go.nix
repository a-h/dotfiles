{ pkgs, stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
    hashes = {
      # Use `print-hashes.sh ${version}` to generate the list below
      # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
      darwin-amd64 = "70bb4a066997535e346c8bfa3e0dfe250d61100b17ccc5676274642447834969";
      darwin-arm64 = "9cab6123af9ffade905525d79fc9ee76651e716c85f1f215872b5f2976782480";
      linux-386 = "1c04cf4440b323a66328e0df95d409f955b9b475e58eae235fdd3d1f1cf02f4f";
      linux-amd64 = "e85278e98f57cdb150fe8409e6e5df5343ecb13cebf03a5d5ff12bd55a80264f";
      linux-arm64 = "7ac7b396a691e588c5fb57687759e6c4db84a2a3bbebb0765f4b38e5b1c5b00e";
      linux-armv6l = "a80fa43d1f4575fb030adbfbaa94acd860c6847820764eecb06c63b7c103612b";
      linux-ppc64le = "070351edac192483c074b38d08ec19251a83f8210765a532a84c3dcf8aec04d8";
      linux-s390x = "ea265f5e62fcaf941d53f0cdb81222d9668e1672a0d39d992f16ff0e87c0ee6b";
    };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.18";

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
