{ config, lib, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
