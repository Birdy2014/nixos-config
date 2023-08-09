{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable =
    lib.mkEnableOption (lib.mdDoc "Whether to enable gaming related programs.");

  config = lib.mkIf cfg.enable {
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
  };
}
