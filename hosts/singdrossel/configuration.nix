# Build using `nix build .#nixosConfigurations.singdrossel.config.system.build.isoImage`

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];

  my = {
    home.stateVersion = config.system.stateVersion;
    sshd.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  boot.swraid.enable = lib.mkForce false;

  isoImage = {
    squashfsCompression = "zstd -Xcompression-level 15";
    isoBaseName = "singdrossel-nixos-custom";
  };

  users.mutableUsers = lib.mkForce false;
  users.users.moritz.password = "";
  services.getty.autologinUser = lib.mkForce "moritz";

  environment.systemPackages = [ pkgs.gparted pkgs.glxinfo ];

  home-manager.users.moritz.wayland.windowManager.sway.extraConfig = ''
    output * bg ${
      pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/NixOS/nixos-artwork/c68a508b95baa0fcd99117f2da2a0f66eb208bbf/wallpapers/nix-wallpaper-gear.png";
        hash = "sha256-2sT6b49/iClTs9QuUvpmZ5gcIeXI9kebs5IqgQN1RL8=";
      }
    } fill
  '';
}
