{ lib, pkgs, ... }:

{
  systemd.user.services.flake-update.Service.ExecStart = pkgs.writeShellScript "flake-update" ''
    if [[ "$(( 10#$(date '+%s') - $(${lib.getExe pkgs.nix} eval --json /etc/nixos#nixosConfigurations.rotkehlchen._module.specialArgs.inputs.nixpkgs.lastModified) ))" -lt 432000 ]]; then
      echo 'flake inputs not updated'
      ${lib.getExe' pkgs.dbus "dbus-send"} --system / net.nuetzlich.SystemNotifications.Notify \
        'string:nixos config' 'string:flake inputs not updated'
      exit
    fi

    cd /etc/nixos
    ${lib.getExe pkgs.nix} flake update --commit-lock-file
    echo 'flake inputs updated'
    ${lib.getExe' pkgs.dbus "dbus-send"} --system / net.nuetzlich.SystemNotifications.Notify \
      'string:nixos config' 'string:flake inputs updated'
  '';

  systemd.user.timers.flake-update = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      OnCalendar = "Sat *-*-* 00:00:00";
      Persistent = true;
    };
  };

}
