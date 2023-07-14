{ pkgs, ... }:

{
  # Epson scanner
  hardware.sane.enable = true;
  users.users.moritz.extraGroups = [ "scanner" "lp" ];
  hardware.sane.extraBackends = [ pkgs.utsushi ];
  services.udev.packages = [ pkgs.utsushi ];

  environment.systemPackages = [ pkgs.simple-scan ];
}
