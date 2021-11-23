{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "Joe-Davidson1802";
    repo = "xc";
    rev = "2d8273a010d655576034e06e38a0c900c3b0638c";
    sha256 = "0k5q2f1h1w0xy2301fn450bm82kaxyv6v288sym2dzsm9s03smsa";
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
