{ config, ... }:

{
  boot.initrd = {
    kernelModules = [ "r8169" ];

    systemd = {
      enable = true;
      network = let stage2 = config.systemd.network;
      in {
        enable = true;
        # Cant use "inherit" here because of a bug in nixfmt.
        # TODO: change this on nixfmt > 0.6.0
        links = { "10-lan" = stage2.links."10-lan"; };
        networks = { "10-lan" = stage2.networks."10-lan"; };
      };
    };

    secrets = {
      "/etc/ssh/initrd_ssh_host_ed25519_key" =
        "/etc/ssh/initrd_ssh_host_ed25519_key";
      "/etc/ssh/initrd_ssh_host_rsa_key" = "/etc/ssh/initrd_ssh_host_rsa_key";
    };

    network.ssh = {
      enable = true;
      port = 2222;
      hostKeys = [
        "/etc/ssh/initrd_ssh_host_ed25519_key"
        "/etc/ssh/initrd_ssh_host_rsa_key"
      ];
    };

    # Automatically execute "systemctl default" (which shows the password prompt) once a user logs in via ssh.
    systemd.services.zfs-remote-unlock = {
      description = "Prepare for ZFS remote unlock";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-networkd.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        echo "systemctl default" >> /var/empty/.profile
      '';
    };
  };
}
