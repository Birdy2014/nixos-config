{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/buntspecht.nix
    ./filesystems.nix
    ./network.nix
    ./nginx.nix
    ./services
  ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
    systemd-boot.enable = true;
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  nixpkgs.hostPlatform = "aarch64-linux";

  # buntspecht has very little storage
  nix.gc = {
    dates = lib.mkForce "weekly";
    options = lib.mkForce "--delete-older-than 14d";
  };

  services.openssh.ports = [ 46773 ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Holding the spacebar doesn't seem to work on the hetzner console
  boot.loader.timeout = lib.mkForce 5;

  # Reduce closure size
  documentation.nixos.enable = false;
  boot.enableContainers = false;
  environment.stub-ld.enable = false;

  system.stateVersion = "23.05";
}
