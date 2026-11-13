{
  jail,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    home.packages = [
      (pkgs.steam.override {
        extraBwrapArgs = [
          "--bind ~/.local/share/jail.nix/home/steam ~"
          "--setenv NIXOS_XDG_OPEN_USE_PORTAL 1"
          "--ro-bind $XDG_DATA_HOME/icons $XDG_DATA_HOME/icons"
        ];
      })

      (jail "heroic" pkgs.heroic (
        with jail.combinators;
        [
          (persist-home "heroic")
          desktop
          gpu
          unsafe-x11
          network
          notifications
          gamepads
          (readwrite "/run/media/moritz/games/Heroic")
        ]
      ))

      (jail "prismlauncher" pkgs.prismlauncher (
        with jail.combinators;
        [
          desktop
          gpu
          unsafe-x11
          network
          (readwrite-xdg "PrismLauncher")
          (readonly (noescape "~/Downloads"))
        ]
      ))

      (jail "dolphin-emu" pkgs.dolphin-emu (
        with jail.combinators;
        [
          desktop
          gpu
          unsafe-x11
          gamepads
          (readwrite-xdg "dolphin-emu")
          (readonly "/run/media/moritz/games/wii")
          (readonly "/run/media/moritz/games/gc")
        ]
      ))

      (jail "rpcs3" pkgs.rpcs3 (
        with jail.combinators;
        [
          desktop
          gpu
          gamepads
          (readwrite-xdg "rpcs3")
          (readonly "/run/media/moritz/games/ps3")
        ]
      ))

      (jail "eden" pkgs.eden (
        with jail.combinators;
        [
          desktop
          gpu
          unsafe-x11
          gamepads
          (readwrite-xdg "eden")
          (readwrite "/run/media/moritz/games/switch")
        ]
      ))
    ];
  };
}
