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
    libsForQt5.kio-extras # for accessing SMB shares

    libreoffice
    thunderbird
    mumble
  ];
}
