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
      pkgs.curl
    ]
    ++ (lib.optional cfg.notify pkgs.dbus);
    text = ''
      ${lib.optionalString cfg.notify ''
        send_notification() {
          dbus-send --system / net.nuetzlich.SystemNotifications.Notify \
            'string:nixos-pull-deploy' "string:$1"
        }

        if [[ "$DEPLOY_STATUS" == 'pre' ]]; then
          send_notification 'Aktualisierung startet'
        fi
      ''}

      if [[ "$DEPLOY_STATUS" == 'pre' ]] && [[ -d '/etc/nixos-secrets' ]]; then
        git -C /etc/nixos-secrets pull
      fi

      if [[ "$DEPLOY_SCHEDULED" == '1' ]] \
        && [[ "$DEPLOY_STATUS" == 'failed' ]] \
        && [[ -e '${config.sops.secrets.ntfy-sender-token.path}' ]]; then
        curl -s \
          -u ":$(< ${config.sops.secrets.ntfy-sender-token.path})" \
          -H "Title: deployment on $(hostname) failed" \
          -d "type: $DEPLOY_TYPE\ncommit: $DEPLOY_COMMIT\nmode: $DEPLOY_MODE" \
          https://ntfy.mvogel.dev/monitoring
      fi

      ${lib.optionalString cfg.notify ''
        if [[ "$DEPLOY_STATUS" == 'success' ]]; then
          send_notification 'Aktualisierung erfolgreich abgeschlossen'
        fi

        if [[ "$DEPLOY_STATUS" == 'failed' ]]; then
          send_notification 'Aktualisierung fehlgeschlagen'
        fi
      ''}
    '';
  };

  acPowerCondition = pkgs.writeShellScript "nixos-pull-deploy-condition.sh" ''
    shopt -s nullglob

    for ac in /sys/class/power_supply/AC*; do
        [[ "$(< "$ac/online")" == 1 ]] && exit 0
    done

    for bat in /sys/class/power_supply/BAT*; do
        [[ "$(< "$bat/status")" == 'Charging' ]] && exit 0
    done

    exit 1
  '';
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
    mainDeployMode = lib.mkOption {
      type = lib.types.enum [
        "boot"
        "switch"
        "reboot_on_kernel_change"
      ];
      default = if cfg.laptopMode then "boot" else "switch";
      description = "How to deploy from the main branch";
    };
    laptopMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only run on AC power and limit cpu usage";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nixos-pull-deploy = {
      enable = true;
      autoUpgrade = {
        enable = true;

        startAt =
          if cfg.laptopMode then
            # Run overy hour on laptops
            "*-*-* *:00:00"
          else
            # on seidenschwanz, jellyfin indexes the media library and zfs snapshots at 02:00
            "*-*-* 01:30:00";
      };
      settings = {
        origin = {
          url = "https://github.com/Birdy2014/nixos-config";
          main = "main";
          testing_prefix = "testing-";
        };
        hook = "${hook}/bin/hook.sh";

        deploy_modes = {
          main = cfg.mainDeployMode;
          testing = "switch";
        };
      };
    };

    systemd.services.nixos-pull-deploy.serviceConfig = lib.mkIf cfg.laptopMode {
      CPUQuota = "50%";
      ExecCondition = acPowerCondition;
    };
  };
}
