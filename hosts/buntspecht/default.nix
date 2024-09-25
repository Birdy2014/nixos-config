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
    systemd-boot.enable = true;
  };

  services.openssh.ports = [ 46773 ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  system.stateVersion = "23.05";
}
