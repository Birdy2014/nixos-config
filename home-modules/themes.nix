{ inputs, pkgs, config, ... }:

{
  imports = [
    ./xdg.nix
  ];

  home.pointerCursor = {
    name = "LyraX-cursors";
    size = 24;
    package = inputs.self.packages.x86_64-linux.lyrax-cursors;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    iconTheme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    font = {
      name = "sans-serif";
      size = 10;
    };

    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Music"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "kvantum-dark";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Gruvbox-Dark-Green
    '';

    "Kvantum/Gruvbox-Dark-Green".source = "${inputs.self.packages.x86_64-linux.gruvbox-kvantum-themes}/share/Kvantum/Gruvbox-Dark-Green";
  };
}
