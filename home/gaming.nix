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
      (jail "steam" pkgs.steam (
        with jail.combinators;
        [
          (persist-home "steam")
          desktop
          gpu
          unsafe-x11
          network
          notifications
          gamepads
          (share-ns "ipc")
          (readwrite "/run/media/moritz/games/Steam-Linux")
          (readwrite "/run/media/moritz/games/Steam-Images")
          (dbus {
            own = [ "com.steampowered.*" ];
          })
        ]
      ))

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
