{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "lepton-firefox-theme";
  version = "8.7.5-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "1bd41b775278d0172b0241372c335da31ebefd9e";
    hash = "sha256-ivQRvSBVLi/aviNZFu8TjTyjAf77Luo6sEZkK7XTMAI=";
  };

  installPhase = ''
    cp -r . "$out"
  '';

  dontFixup = true;

  meta = {
    homepage = "https://github.com/black7375/Firefox-UI-Fix";
    description = "🦊 I respect proton UI and aim to improve it.";
  };
}
