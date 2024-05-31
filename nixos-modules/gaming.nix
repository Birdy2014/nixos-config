{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ corefonts ];
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      # Launchers
      heroic
      prismlauncher
      (lutris.override { extraPkgs = pkgs: [ wineWowPackages.stable ]; })

      # Emulators
      dolphin-emu
      rpcs3

      # Tools
      mangohud
    ];

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
