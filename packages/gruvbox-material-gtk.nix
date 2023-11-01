{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gruvbox-material-gtk";
  version = "20230828";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "a1295d8bcd4dfbd0cd6793d7b1583b442438ed89";
    hash = "sha256-VumO8F4ZrFI6GZU1XXaw4MCnP+Nla1rVS3uuSUzpl9E=";
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
