{ config, lib, pkgs, ... }:

{
  programs.firejail = rec {
    enable = wrappedBinaries != { };

    wrappedBinaries = lib.mkIf config.my.gaming.enable {
      prismlauncher = {
        executable = "${pkgs.prismlauncher}/bin/prismlauncher";
        profile = ./prismlauncher.profile;
      };
    };
  };
}
