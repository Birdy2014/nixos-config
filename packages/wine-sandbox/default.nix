{
  lib,
  stdenvNoCC,
  makeWrapper,
  python3,
  bubblewrap,
  wineWow64Packages,
}:

stdenvNoCC.mkDerivation {
  pname = "wine-sandbox";
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  dontUnpack = true;

  installPhase = ''
    install -Dm755 ${./wine-sandbox.py} $out/bin/wine-sandbox

    wrapProgram $out/bin/wine-sandbox \
      --prefix PATH : ${
        lib.makeBinPath [
          bubblewrap
          wineWow64Packages.stable
        ]
      }
  '';
}
