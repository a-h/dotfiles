{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.48";

  src = fetchFromGitHub {
    owner = "Joe-Davidson1802";
    repo = "xc";
    rev = "f2d8bec149c51eda91cac8e3d10352ab1b9ad100";
    sha256 = "16v3mszhvq2rawikzrpwil3j8lj9lvb1ml6mf0k6mzqjb0q3ymi6";
  };

  vendorSha256 = "1ryb8m407rijrwlxcpkwyayjf1raxi2qw4ndpjsi12q1bjhx0y33";

  meta = with lib; {
    description = "eXeCute project tasks from a readme file";
    homepage = https://github.com/Joe-Davidson1802/xc;
    license = licenses.mit;
    maintainers = with maintainers; [ Joe-Davidson1802 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
