{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      # TODO: Remove in NixOS 24.11, because fontPackages defaults to system fonts
      extraPackages = with pkgs; [ corefonts ];
      remotePlay.openFirewall = true;
    };

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
