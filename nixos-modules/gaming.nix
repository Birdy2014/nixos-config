{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    prismlauncher
    yuzu-mainline
    dolphin-emu
    mangohud
  ];

  boot.blacklistedKernelModules = [ "hid_nintendo" ];
}
