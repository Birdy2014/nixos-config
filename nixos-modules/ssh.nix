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
        AcceptEnv = "COLORTERM";
      };
    };

    users.users =
      let
        keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDW/ScGgC6eoHVvEKAILBiGSushbr+kz8gLLL9DLQHHuvd/o54AnQvuiZ7MOmmwnakJD3sMXxIyAqx1gZn94i0woATvvVDK+IeakIXl+854y/MVuNf0NjdOGBcrppasqZqZAp1yflXDwqvDhHDtuiNyP/9KOE6I9ysjV63iegP6Weka7bvyspRLeLIRiGJuIt+j6jEQmWevaWndnTuVDBx49VZUfev7t+aRdBbhRUfRb0I2W0aj67P1lvLkzCqtuYk/fzHD30rYu6tnAGs1BJrX2ssRg94cXbMf2K4KeRgofBXGwNaPDTsOGzq4v03THP7abFjoemaXVnTucdjhhG7YKgk4+7nDBFEYhlXtDOdQ/ugF8npY6kkLlvZHVqYh/kOoyV3mh3OROdS/eIMKUSxKEP0FqbUNDzhMltlKEDcf53dFuNYkt8OdAnYw+yp13V+9/xf8l9rttIpGBVfdzb7SA+MX/hfjAprs4/3qXqXJ5f2oHh/QfvHp8dOPaGpKEic= moritz@rotkehlchen-2020-04-15"
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
