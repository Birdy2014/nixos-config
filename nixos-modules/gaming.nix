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
    pcsx2
    rpcs3
    mangohud
  ];

  boot.blacklistedKernelModules = [ "hid_nintendo" ];
}
