{ stdenv, fetchFromGitHub, inkscape, xcursorgen, ... }:

stdenv.mkDerivation {
  pname = "LyraX Cursors";
  version = "20211204";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Lyra-Cursors";
    rev = "c096c54034f95bd35699b3226250e5c5ec015d9a";
    hash = "sha256-lfaX8ouE0JaQwVBpAGsrLIExQZ2rCSFKPs3cch17eYg=";
  };

  buildInputs = [ inkscape xcursorgen ];

  buildPhase = ''
    rm -rf ./dist/*
    sed -i 's/create svg/create LyraX-svg/' build.sh
    sed -i 's/LyraR Cursors/LyraX Cursors/' build.sh
    bash ./build.sh
  '';

  installPhase = ''
    mkdir -p "$out/share/icons/LyraX-cursors"
    cp -r ./dist/* "$out/share/icons/LyraX-cursors/"
  '';

  dontFixup = true;

  meta = {
    homepage = "https://github.com/yeyushengfan258/Lyra-Cursors";
    description = "Lyra Cursors for linux desktops";
  };
}
