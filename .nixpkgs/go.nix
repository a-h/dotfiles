{ pkgs, stdenv, fetchurl }:

let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    # https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/compilers/go/print-hashes.sh
    darwin-amd64 = "828eeca8b5abea3e56921df8fa4b1101380a5ebcfee10acbc8ffe7ec0bf5876b";
    darwin-arm64 = "923a377c6fc9a2c789f5db61c24b8f64133f7889056897449891f256af34065f";
    linux-386 = "0c44f85d146c6f98c34e8ff436a42af22e90e36fe232d3d9d3101f23fd61362b";
    linux-amd64 = "9e5de37f9c49942c601b191ac5fba404b868bfc21d446d6960acc12283d6e5f2";
    linux-arm64 = "006f6622718212363fa1ff004a6ab4d87bbbe772ec5631bab7cac10be346e4f1";
    linux-armv6l = "d5ac34ac5f060a5274319aa04b7b11e41b123bd7887d64efb5f44ead236957af";
    linux-ppc64le = "2e37fb9c7cbaedd4e729492d658aa4cde821fc94117391a8105c13b25ca1c84b";
    linux-s390x = "e3d536e7873639f85353e892444f83b14cb6670603961f215986ae8e28e8e07a";
  };

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "1.18.5";

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
