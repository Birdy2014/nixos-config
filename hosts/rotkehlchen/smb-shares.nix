{ lib, ... }:

{
  fileSystems = lib.listToAttrs (map (name: {
    name = "/run/media/moritz/smb-shares/${name}";
    value = {
      device = "//seidenschwanz.mvogel.dev/${name}";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts =
          "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in [ "${automount_opts},credentials=/smb-secrets,uid=1000,gid=100" ];
    };
  }) [ "family" "moritz" ]);
}
