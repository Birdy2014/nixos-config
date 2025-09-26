{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.pull-deploy;
in
{
  imports = [ inputs.nixos-pull-deploy.nixosModules.default ];

  options.my.pull-deploy = {
    enable = lib.mkEnableOption "automatic pull deployments";
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
        hook = pkgs.writeShellScript "hook.sh" ''
          if [[ "$DEPLOY_STATUS" == 'pre' ]] && [[ -d '/etc/nixos-secrets' ]]; then
            git -C /etc/nixos-secrets pull
          fi
        '';
      };
    };
  };
}
