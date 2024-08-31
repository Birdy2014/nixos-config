{ lib, pkgs, ... }:

{
  systemd.services.openseachest = let
    devices = [ "/dev/sda" "/dev/sdb" ];

    # In milliseconds

    # Discs rotating at full speed
    idle_a = "100";

    # Heads are unloaded to drive ramp
    # Discs rotating at full speed
    idle_b = "120000";

    # Heads are unloaded to drive ramp
    # Drive speed reduced to a lower RPM
    idle_c = "600000";

    # Heads are unloaded to drive ramp
    # Drive motor is spun down
    standby_z = "disable";
  in {
    script = lib.concatMapStringsSep "\n" (device:
      "openSeaChest_PowerControl --device ${device} --idle_a ${idle_a} --idle_b ${idle_b} --idle_c ${idle_c} --standby_z ${standby_z}")
      devices;
    path = [ pkgs.openseachest ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
