{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.pull-deploy;

  hook = pkgs.writeShellApplication {
    name = "hook.sh";
    runtimeInputs = [
      pkgs.git
      pkgs.openssh
    ]
    ++ (lib.optional cfg.notify pkgs.dbus);
    text = ''
      if [[ "$DEPLOY_STATUS" == 'pre' ]] && [[ -d '/etc/nixos-secrets' ]]; then
        git -C /etc/nixos-secrets pull
      fi

      ${lib.optionalString cfg.notify ''
        send_notification() {
          dbus-send --system / net.nuetzlich.SystemNotifications.Notify \
            'string:nixos-pull-deploy' "string:$1"
        }

        if [[ "$DEPLOY_STATUS" == 'success' ]]; then
          send_notification 'Aktualisierung erfolgreich abgeschlossen'
        fi

        if [[ "$DEPLOY_STATUS" == 'failed' ]]; then
          send_notification 'Aktualisierung fehlgeschlagen'
        fi
      ''}
    '';
  };
in
{
  imports = [ inputs.nixos-pull-deploy.nixosModules.default ];

  options.my.pull-deploy = {
    enable = lib.mkEnableOption "automatic pull deployments";
    notify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Send a desktop notification of success and failure";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nixos-pull-deploy = {
      enable = true;
      autoUpgrade = {
        enable = true;

        # on seidenschwanz, jellyfin indexes the media library and zfs snapshots at 02:00
        startAt = "*-*-* 01:30:00";
      };
      settings = {
        origin = {
          url = "https://github.com/Birdy2014/nixos-config";
          main = "main";
          testing = "testing-";
        };
        hook = "${hook}/bin/hook.sh";
      };
    };

    # TODO: upstream this if it works
    systemd.timers.nixos-pull-deploy = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      timerConfig.Persistent = true;
    };
  };
}
