{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/buntspecht.nix
    ./borg.nix
    ./filesystems.nix
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

  # Holding the spacebar doesn't seem to work on the hetzner console
  boot.loader.timeout = lib.mkForce 5;

  # Too little ram. Remove after nix 2.30?
  boot.tmp.useTmpfs = lib.mkForce false;

  # Reduce closure size
  documentation.nixos.enable = false;
  boot.enableContainers = false;
  environment.stub-ld.enable = false;

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  system.stateVersion = "23.05";
}
