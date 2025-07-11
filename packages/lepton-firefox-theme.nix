{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "lepton-firefox-theme";
  version = "8.7.2";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-t0mEpG2f43wdssmq7CXjQj01IzRYS2dy5N2US0gKTVA=";
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
