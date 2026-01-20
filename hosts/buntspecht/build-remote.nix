{ pkgs, ... }:

{
  nix.settings.allowed-users = [ "buildremote" ];
  users.groups.buildremote = { };
  users.users.buildremote =
    let
      ssh-restrict = "restrict,pty,command=\"${wrapper-dispatch-ssh-nix}/bin/wrapper-dispatch-ssh-nix\" ";
      wrapper-dispatch-ssh-nix = pkgs.writeShellScriptBin "wrapper-dispatch-ssh-nix" ''
        case $SSH_ORIGINAL_COMMAND in
          'nix '*|'nix-store '*)
            mkdir -p /tmp/buildremote-nix-cache
            exec env HOME=/tmp/buildremote bash -c "$SSH_ORIGINAL_COMMAND"
            ;;
          *)
            echo "Access only allowed for using nixos-pull-deploy" 1>&2
            echo "tried to execute $SSH_ORIGINAL_COMMAND" 1>/tmp/abc
            exit
        esac
      '';
    in
    {
      isSystemUser = true;
      group = "buildremote";
      shell = pkgs.bash;
      openssh.authorizedKeys.keys =
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBj1FEMHPeSO4ld+WlC4radY6/vXg5IIzb22xyV/U5Y root@haussperling"
        ]
        |> map (key: ssh-restrict + key);
    };
}
