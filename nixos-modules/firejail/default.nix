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
        # The string apparently gets executed using bash by nix, so the string interpolation
        # has to be escaped two times.
        extraArgs = let
          steam_home = "\\\${HOME}/.local/share/steam";
          # "--mkdir" gets executed both in the real filesystem and in the private fs.
          # Is it possible to only execute it on the real fs?
          # See https://github.com/netblue30/firejail/issues/903
        in [ "--noprofile" "--mkdir=${steam_home}" "--private=${steam_home}" ];
      };
    };
  };
}
