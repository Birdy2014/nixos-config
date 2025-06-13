# Build using `nix build .#nixosConfigurations.singdrossel.config.system.build.isoImage`

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];

  my = {
    home.stateVersion = config.system.stateVersion;
    sshd.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  services.resolved.enable = true;

  isoImage.squashfsCompression = "zstd -Xcompression-level 15";
  system.nixos.tags = [ "singdrossel" ];

  users.mutableUsers = lib.mkForce false;
  users.users.moritz.password = "";
  services.getty.autologinUser = lib.mkForce "moritz";

  security.pam.services.login.allowNullPassword = true;
  security.pam.services.swaylock.allowNullPassword = true;

  environment.systemPackages = [
    pkgs.gparted
    pkgs.glxinfo
  ];

  home-manager.users.moritz.wayland.windowManager.sway.extraConfig =
    "output * bg ${pkgs.nixos-artwork.wallpapers.gear}/share/backgrounds/nixos/nix-wallpaper-gear.png fill";
}
