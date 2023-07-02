{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gruvbox-material-gtk";
  version = "20230425";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "558c2e174c00974685e4fc74c0fbc801018a2bbf";
    hash = "sha256-hqQGl1Yv/xqGnhsVlpHun3phhNRRG1sC4LzDTFNQ7CY=";
  };

  installPhase = ''
    mkdir -p "$out/share/themes/"
    mkdir -p "$out/share/icons/"
    cp -r './themes/Gruvbox-Material-Dark' "$out/share/themes/"
    cp -r './themes/Gruvbox-Material-Dark-HIDPI' "$out/share/themes/"
    cp -r './icons/Gruvbox-Material-Dark' "$out/share/icons/"
  '';

  dontFixup = true;

  meta = {
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    description =
      "Gruvbox Material for GTK, Gnome, Cinnamon, XFCE, Unity, Plank and Icons ";
  };
}
