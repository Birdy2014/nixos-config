{ config, lib, ... }:

{
  fileSystems = lib.listToAttrs (
    map
      (name: {
        name = "/run/media/moritz/smb-shares/${name}";
        value = {
          device = "//seidenschwanz.mvogel.dev/${name}";
          fsType = "cifs";
          options =
            let
              # this line prevents hanging on network split
              automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
            in
            [
              "${automount_opts},credentials=${
                config.sops.templates."seidenschwanz-smb-credentials".path
              },uid=1000,gid=100,file_mode=0644"
            ];
        };
      })
      [
        "family"
        "moritz"
      ]
  );

  sops.templates."seidenschwanz-smb-credentials".content = ''
    username=moritz
    password=${config.sops.placeholder.seidenschwanz-smb-password}
  '';
}
