{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.scan;
in
{
  options.my.scan.enable = lib.mkEnableOption "SANE and simple-scan";

  config = lib.mkIf cfg.enable {
    # Epson scanner
    hardware.sane.enable = true;
    users.users.moritz.extraGroups = [
      "scanner"
      "lp"
    ];
    hardware.sane.extraBackends = [ pkgs.utsushi ];
    services.udev.packages = [ pkgs.utsushi ];

    environment.systemPackages = [ pkgs.simple-scan ];
  };
}
