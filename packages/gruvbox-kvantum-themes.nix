{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gruvbox-kvantum-themes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "sachnr";
    repo = "gruvbox-kvantum-themes";
    rev = "439fe6df66644579abcd11169200c8a20a134d5f";
    hash = "sha256-orAPLYxl9/KMzGlX7YCpq5FTKa/4FG8/qEv2xdC9QOM=";
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
