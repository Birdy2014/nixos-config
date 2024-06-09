{ ... }:

{
  imports = [
    ../../secrets/buntspecht-seidenschwanz.nix
    ../../secrets/buntspecht.nix
    ./hardware-configuration.nix
    ./network.nix
    ./services
  ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  services.openssh.ports = [ 46773 ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  system.stateVersion = "23.05";
}
