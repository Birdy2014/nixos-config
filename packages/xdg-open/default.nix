{ lib, stdenvNoCC, makeWrapper, coreutils, python3 }:

stdenvNoCC.mkDerivation {
  pname = "xdg-open";
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  dontUnpack = true;

  installPhase = ''
    install -Dm755 ${./xdg-open.py} $out/bin/xdg-open

    wrapProgram $out/bin/xdg-open \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  meta = {
    description = "My xdg-open replacement";
    priority = -10;
  };
}
