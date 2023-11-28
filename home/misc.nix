{ pkgs, ... }:

{
  services.easyeffects.enable = true;

  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

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

    libreoffice
    thunderbird
    mumble
  ];
}
