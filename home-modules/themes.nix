{ self, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Material-Dark";
      package = self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    cursorTheme = {
      name = "LyraX-cursors";
    };
  };

  qt.platformTheme = "qt5ct";
  home.packages = with pkgs; [
    qt5ct
    libsForQt5.qtstyleplugin-kvantum
  ];
}
