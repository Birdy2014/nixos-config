{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/minimal.nix")
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/buntspecht.nix
    ./borg.nix
    ./build-remote.nix
    ./filesystems.nix
    ./geoblock.nix
    ./network.nix
    ./services
  ];

  my = {
    sshd.enable = true;
    systemd-boot.enable = true;
    pull-deploy = {
      enable = true;
      mainDeployMode = "reboot_on_kernel_change";
    };
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  nixpkgs.hostPlatform = "aarch64-linux";

  # buntspecht has very little storage
  nix.gc = {
    dates = lib.mkForce "weekly";
    options = lib.mkForce "--delete-older-than 14d";
  };

  services.openssh.ports = [ 46773 ];

  networking.firewall.logRefusedConnections = false;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.commonHttpConfig = ''
    access_log off;
  '';

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  # buntspecht is a vm
  services.smartd.enable = lib.mkForce false;

  # Holding the spacebar doesn't seem to work on the hetzner console
  boot.loader.timeout = lib.mkForce 5;

  # Too little ram. Remove after nix 2.30?
  boot.tmp.useTmpfs = lib.mkForce false;

  system.stateVersion = "23.05";
}
