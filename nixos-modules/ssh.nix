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
      };
    };

    users.users =
      let
        keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDW/ScGgC6eoHVvEKAILBiGSushbr+kz8gLLL9DLQHHuvd/o54AnQvuiZ7MOmmwnakJD3sMXxIyAqx1gZn94i0woATvvVDK+IeakIXl+854y/MVuNf0NjdOGBcrppasqZqZAp1yflXDwqvDhHDtuiNyP/9KOE6I9ysjV63iegP6Weka7bvyspRLeLIRiGJuIt+j6jEQmWevaWndnTuVDBx49VZUfev7t+aRdBbhRUfRb0I2W0aj67P1lvLkzCqtuYk/fzHD30rYu6tnAGs1BJrX2ssRg94cXbMf2K4KeRgofBXGwNaPDTsOGzq4v03THP7abFjoemaXVnTucdjhhG7YKgk4+7nDBFEYhlXtDOdQ/ugF8npY6kkLlvZHVqYh/kOoyV3mh3OROdS/eIMKUSxKEP0FqbUNDzhMltlKEDcf53dFuNYkt8OdAnYw+yp13V+9/xf8l9rttIpGBVfdzb7SA+MX/hfjAprs4/3qXqXJ5f2oHh/QfvHp8dOPaGpKEic= moritz@rotkehlchen-2020-04-15"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDp4SxBNSzsPrR5tgKYatDBzUj3i9/jwGk6N3+UsQj74GTVcyNVz9XGAA5IKoR1v2QjnFHBQ1gFokddAXjVavzeGfqo2FEFK4IM4ZA+QTPxXQ7U6MvV3i/jCJDgBbUQaT6vdThyhDSV/2y+rFFw96tmGp5JwHamEw3VbgX01mFWCmPYgWs6YBkQ1o3MtH6Ou5OleNjczXxKcPLI6PyiaCAFkrI0zZwSSmhWZ8bC87mhpD7dPcE22Ll2pKBR29a0lcped1KPFucMkpR4dItakh+PxaS5JCfcw5nPHwWfbyWfct4MdrRjjLwgfDmkvRyBODjcUryvpuT0FGeYASqZN/J0k0qTq+uhgxB5DVntuf/Kh3Cc+oXTtH0TRfdVYLK6Lkw5GMoS7vSt4qUNUKrYnuVHFHbu2hNIGRi78bhEvtzkCbpXxjmwDi+5P9lPVJSkHTsTlLJE1Cryx9XsDQ8zMS3nAQjTbahMSBRfr9RLlfqvtooBbcVvjilkoTb64JCYiPU= moritz@zilpzalp"
        ];
      in
      {
        root.openssh.authorizedKeys.keys = keys;
        moritz = lib.mkIf (config.my.desktop.enable) {
          openssh.authorizedKeys.keys = keys;
        };
      };
  };
}
