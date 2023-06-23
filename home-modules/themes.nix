{ inputs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    cursorTheme = {
      name = "LyraX-cursors";
      package = inputs.self.packages.x86_64-linux.lyrax-cursors;
    };

    font = {
      name = "sans-serif";
      size = 10;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Gruvbox-Dark-Green
    '';

    "Kvantum/Gruvbox-Dark-Green".source = "${inputs.self.packages.x86_64-linux.gruvbox-kvantum-themes}/share/Kvantum/Gruvbox-Dark-Green";
  };

  # TODO: qt5ct config file
}
