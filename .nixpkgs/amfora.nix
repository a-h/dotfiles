{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "amfora";
  version = "v1.4.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "887a98ed25975926f29bb1c5c2887b8c29553af8";
    sha256 = "1z4r1yqy5nkfa7yqcsqpqfdcghw8idryzb3s6d6ibca47r0qlcvw";
  };

  vendorSha256 = "0xj2s14dq10fwqqxjn4d8x6zljd5d15gjbja2gb75rfv09s4fdgv";

  meta = with lib; {
    description = "The best looking Gemini client with the most features.";
    homepage = https://github.com/makeworld-the-better-one/amfora;
    license = licenses.isc;
    maintainers = with maintainers; [ makeworld-the-better-one ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
