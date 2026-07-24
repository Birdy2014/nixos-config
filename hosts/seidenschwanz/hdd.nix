{ lib, pkgs, ... }:

{
  systemd.services.openseachest =
    let
      devices = [
        "/dev/sda"
        "/dev/sdb"
      ];

      # In milliseconds

      # Reduced electronics
      idle_a = "1000"; # Highest possible value

      # Heads unloaded.
      # Disks spinning at full RPM.
      idle_b = "1800000";

      # Heads unloaded.
      # Disks spinning at reduced RPM.
      idle_c = "3600000";

      # Heads unloaded.
      # Motor stopped (disks not spinning).
      standby_z = "disable";
    in
    {
      script = lib.concatMapStringsSep "\n" (
        device:
        "openSeaChest_PowerControl --device ${device} --idle_a ${idle_a} --idle_b ${idle_b} --idle_c ${idle_c} --standby_z ${standby_z}"
      ) devices;
      path = [ pkgs.openseachest ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
}
