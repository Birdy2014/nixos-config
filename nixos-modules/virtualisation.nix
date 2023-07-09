{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  users.users.moritz.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [ distrobox virt-manager ];
}
