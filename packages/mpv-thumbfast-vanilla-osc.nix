{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "mpv-thumbfast-vanilla-osc";
  version = "2023-12-21";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "5fefc9b8e995cf5e663666aa10649af799e60186";
    hash = "sha256-6nICOdtPzDQUMufqCJ+g2OnPasOgp3PegnRoWw8TVBU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/mpv/scripts"
    install -Dm644 './player/lua/osc.lua' "$out/share/mpv/scripts/"
    runHook postInstall
  '';

  passthru.scriptName = "osc.lua";

  meta = {
    homepage = "https://github.com/po5/thumbfast";
    description = "High-performance on-the-fly thumbnailer script for mpv";
  };
}
