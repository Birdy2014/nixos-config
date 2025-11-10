{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.podman;
in
{
  options.my.podman.enable = lib.mkEnableOption "podman, distrobox";

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = with pkgs; [ distrobox ];
  };
}
