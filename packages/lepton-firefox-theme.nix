{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "lepton-firefox-theme";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-qiJmA25HVw/IOQictcnhTxXfbUWQ11TTEcQTEzIeMug=";
  };

  patches = [
    # See https://github.com/black7375/Firefox-UI-Fix/issues/864
    # Remove with next release
    (fetchpatch {
      url =
        "https://github.com/black7375/Firefox-UI-Fix/commit/4545b12bbcedca327b4692c8e73685c33669237f.diff";
      hash = "sha256-g7P7dTkjxYf1ONCX7oATDrJjKwq6sVrFHkPLkwQLqJE=";
    })
  ];

  installPhase = ''
    cp -r . "$out"
  '';

  dontFixup = true;

  meta = {
    homepage = "https://github.com/black7375/Firefox-UI-Fix";
    description = "🦊 I respect proton UI and aim to improve it.";
  };
}
