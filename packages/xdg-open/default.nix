{ lib, stdenvNoCC, makeWrapper, coreutils, python3, xdg-utils, libnotify }:

stdenvNoCC.mkDerivation {
  pname = "xdg-open";
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ (python3.withPackages (p: [ p.dbus-python ])) ];
  dontUnpack = true;

  installPhase = ''
    install -Dm755 ${./xdg-open.py} $out/bin/xdg-open

    wrapProgram $out/bin/xdg-open \
      --prefix PATH : ${lib.makeBinPath [ coreutils xdg-utils libnotify ]}
  '';

  meta = {
    description = "My xdg-open replacement";
    priority = -10;
  };
}
