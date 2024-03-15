# Build using `nix build .#nixosConfigurations.live-iso.config.system.build.isoImage`

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];

  my = {
    home.stateVersion = config.system.stateVersion;
    sshd.enable = true;
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
}
