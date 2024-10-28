{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "lepton-firefox-theme";
  version = "8.6.3";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-Id3YphCYrnw1vWy/z2psAEM71Tvy0t5q8pVdxneKYRg=";
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
