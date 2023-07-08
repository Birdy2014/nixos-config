{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # for RPCS3
  security.pam.loginLimits = [
    {
      domain = "moritz";
      item = "memlock";
      type = "soft";
      value = 2097152;
    }
    {
      domain = "moritz";
      item = "memlock";
      type = "hard";
      value = 2097152;
    }
  ];

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
