{ config, lib, pkgs, ... }:

{
  programs.firejail = {
    enable = true;

    wrappedBinaries = lib.mkIf config.my.gaming.enable {
      prismlauncher = {
        executable = "${pkgs.prismlauncher}/bin/prismlauncher";
        profile = ./prismlauncher.profile;
      };
      steam = {
        executable = "${pkgs.steam}/bin/steam";
        profile = ./steam.profile;
      };
    };
  };
}
