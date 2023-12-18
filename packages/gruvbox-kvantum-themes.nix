{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gruvbox-kvantum-themes";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "sachnr";
    repo = "gruvbox-kvantum-themes";
    rev = "refs/tags/${version}";
    hash = "sha256-u2J4Zf9HuMjNCt3qVpgEffkytl/t277FzOvWL8Nm8os=";
  };

  installPhase = ''
    mkdir -p "$out/share/Kvantum/"
    cp -r './Gruvbox-Dark-Blue' "$out/share/Kvantum/"
    cp -r './Gruvbox-Dark-Brown' "$out/share/Kvantum/"
    cp -r './Gruvbox-Dark-Green' "$out/share/Kvantum/"
    cp -r './Gruvbox_Light_Blue' "$out/share/Kvantum/"
    cp -r './Gruvbox_Light_Brown' "$out/share/Kvantum/"
    cp -r './Gruvbox_Light_Green' "$out/share/Kvantum/"
  '';

  dontFixup = true;

  meta = {
    homepage = "https://github.com/sachnr/gruvbox-kvantum-themes";
    description = "Gruvbox themes for kvantum";
  };
}
