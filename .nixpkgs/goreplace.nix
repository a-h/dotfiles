{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreplace";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "goreplace";
    rev = "653683efc0a6e08da1168c6599216ee81236f95b";
    sha256 = "1ia0yns20q8b9yhmpyavzbb2zvyh960i5v1hbprsb3pqb76h89cg";
  };

  vendorSha256 = "0njcdk1yns5jp9zklpw63r6xvdlz96l1ba66hhngczr3017g66jf";

  meta = with lib; {
    description = "Replace in files.";
    homepage = https://github.com/piranha/goreplace;
    license = licenses.isc;
    maintainers = with maintainers; [ piranha ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
