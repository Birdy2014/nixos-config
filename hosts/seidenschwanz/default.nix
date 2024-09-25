{ pkgs, ... }:

{
  imports = [
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/seidenschwanz.nix
    ./btrbk.nix
    ./ddclient.nix
    ./hardware-configuration.nix
    ./hdd.nix
    ./network.nix
    ./proxy.nix
    ./services
    ./users.nix
    ./zfs.nix
  ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
    systemd-boot.enable = true;
  };

  networking.hostId = "c1004e7c";

  environment.systemPackages = with pkgs; [ openseachest fatrace ];

  system.stateVersion = "23.11";
}
