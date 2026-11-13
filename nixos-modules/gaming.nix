{ config, lib, ... }:

let
  cfg = config.my.gaming;
in
{
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;

    boot.kernelModules = [ "ntsync" ];
  };
}
