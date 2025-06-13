{ pkgs, ... }:

{
  imports = [
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/seidenschwanz.nix
    ./borg.nix
    ./btrbk.nix
    ./ddclient.nix
    ./filesystems.nix
    ./hdd.nix
    ./initrd-ssh-zfs-unlock.nix
    ./network.nix
    ./nullmailer.nix
    ./proxy.nix
    ./services
    ./smartd.nix
    ./users.nix
    ./zfs.nix
  ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
    systemd-boot.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  networking.hostId = "c1004e7c";

  environment.systemPackages = with pkgs; [
    openseachest
    fatrace
  ];
  services.thermald.enable = true;

  system.stateVersion = "23.11";
}
