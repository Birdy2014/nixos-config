{ pkgs, ... }:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    pavucontrol
    helvum
    obsidian
    keepassxc
    zathura
    mcomix
    dolphin
    libsForQt5.kio # needed for the SMB password prompt in dolphin
    libsForQt5.kio-extras # for accessing SMB shares
    neovide

    libreoffice
    thunderbird
    mumble
  ];
}
