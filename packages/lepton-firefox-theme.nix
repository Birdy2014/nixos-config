{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lepton-firefox-theme";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-+TNEtdYePMVBLRUJyzZOKgzFr8tqfqmxy8NfaABP1jw=";
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
