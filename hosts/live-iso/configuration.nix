# Build using `nix build .#nixosConfigurations.live-iso.config.system.build.isoImage`

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];

  my = {
    gaming.enable = false;
    scan.enable = false;
    virtualisation.enable = false;
    home.stateVersion = config.system.stateVersion;
  };

  time.timeZone = "Europe/Amsterdam";

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  boot.swraid.enable = lib.mkForce false;

  isoImage = {
    squashfsCompression = "zstd -Xcompression-level 15";
    isoBaseName = "nixos-custom";
  };

  users.mutableUsers = lib.mkForce false;
  users.users.moritz.password = "";
  services.getty.autologinUser = lib.mkForce "moritz";

  environment.systemPackages = [ pkgs.gparted pkgs.glxinfo ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDW/ScGgC6eoHVvEKAILBiGSushbr+kz8gLLL9DLQHHuvd/o54AnQvuiZ7MOmmwnakJD3sMXxIyAqx1gZn94i0woATvvVDK+IeakIXl+854y/MVuNf0NjdOGBcrppasqZqZAp1yflXDwqvDhHDtuiNyP/9KOE6I9ysjV63iegP6Weka7bvyspRLeLIRiGJuIt+j6jEQmWevaWndnTuVDBx49VZUfev7t+aRdBbhRUfRb0I2W0aj67P1lvLkzCqtuYk/fzHD30rYu6tnAGs1BJrX2ssRg94cXbMf2K4KeRgofBXGwNaPDTsOGzq4v03THP7abFjoemaXVnTucdjhhG7YKgk4+7nDBFEYhlXtDOdQ/ugF8npY6kkLlvZHVqYh/kOoyV3mh3OROdS/eIMKUSxKEP0FqbUNDzhMltlKEDcf53dFuNYkt8OdAnYw+yp13V+9/xf8l9rttIpGBVfdzb7SA+MX/hfjAprs4/3qXqXJ5f2oHh/QfvHp8dOPaGpKEic= moritz@Rotkehlchen-2020-04-15"
  ];
}
