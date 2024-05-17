{ inputs, pkgs, ... }:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    # CLI
    libqalculate
    yt-dlp
    neofetch
    bashmount
    inputs.self.packages.${pkgs.system}.xdg-open
    inputs.self.packages.${pkgs.system}.playerctl-current

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
