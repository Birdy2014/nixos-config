{ pkgs, ... }:

{
  imports = [
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/seidenschwanz.nix
    ./btrbk.nix
    ./ddclient.nix
    ./hardware-configuration.nix
    ./network.nix
    ./proxy.nix
    ./services
    ./users.nix
    ./zfs.nix
  ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };

  networking.hostId = "c1004e7c";

  environment.systemPackages = with pkgs; [ openseachest fatrace ];

  system.stateVersion = "23.11";
}
