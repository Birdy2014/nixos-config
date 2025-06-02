{ fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "mpv-thumbfast-vanilla-osc";
  version = "2025-02-04";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "9d78edc167553ccea6290832982d0bc15838b4ac";
    hash = "sha256-AG3w5B8lBcSXV4cbvX3nQ9hri/895xDbTsdaqF+RL64=";
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
