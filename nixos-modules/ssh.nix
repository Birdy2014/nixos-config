{ config, lib, ... }:

let
  cfg = config.my.sshd;
in
{
  options.my.sshd.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to enable sshd";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;

        # Needed for dircolors to work in foot when connecting over ssh
        AcceptEnv = [ "COLORTERM" ];
      };
    };

    users.users =
      let
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLLJBuP4oFr53Ql22/AcE+4SnLxX8JPep5GTL+g+4Bo moritz@rotkehlchen"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIoGO1D0GjpK4ZkipbeusO2iUJ5hS+5+lgf4HyLYP7w7AAAABHNzaDo= moritz@zilpzalp"
        ];
      in
      {
        root.openssh.authorizedKeys.keys = keys;
        moritz = lib.mkIf config.my.home.enable {
          openssh.authorizedKeys.keys = keys;
        };
      };
  };
}
