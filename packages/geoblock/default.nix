{
  stdenvNoCC,
  makeWrapper,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "geoblock";
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ (python3.withPackages (p: [ p.requests ])) ];
  dontUnpack = true;

  installPhase = ''
    install -Dm755 ${./geoblock.py} $out/bin/geoblock
  '';

  meta.mainProgram = "geoblock";
}
