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
    pkgsSelf.xdg-open
    pkgsSelf.playerctl-current

    # GUI
    pavucontrol
    helvum
    obsidian
    keepassxc
    zathura
    mcomix
    neovide

    libreoffice
    thunderbird
    mumble
  ];
}
