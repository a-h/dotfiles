{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.44";

  src = fetchFromGitHub {
    owner = "Joe-Davidson1802";
    repo = "xc";
    rev = "0902dadea5f556cc578a7254ee45603da9514fb9";
    sha256 = "0wbfbj5bqiq5zzw9x7mhlsqn6lfn1gbl7m6f5vg7wn7hmj6qksqy";
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
