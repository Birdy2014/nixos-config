{ osConfig, pkgs, pkgsSelf, ... }:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  nix.gc = {
    automatic = osConfig.nix.gc.automatic;
    frequency = osConfig.nix.gc.dates;
    options = osConfig.nix.gc.options;
  };

  home.packages = with pkgs; [
    # CLI
    libqalculate
    yt-dlp
    bashmount
    pkgsSelf.playerctl-current
    gdb

    # GUI
    pavucontrol
    helvum
    obsidian
    keepassxc
    zathura
    neovide
    hotspot
    libreoffice
    thunderbird
    element-desktop
  ];
}
