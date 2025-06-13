{
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    my.bubblewrap = {
      steam = {
        applications = [ pkgs.steam ];
        persistentHome = true;
        allowDesktop = true;
        allowX11 = true;
        unshareIpc = false;
        unshareNet = false;
        extraBinds = [
          "/run/media/moritz/games/Steam-Linux"
          "/run/media/moritz/games/Steam-Images"
          "/sys/class/input"
        ];
        extraDevBinds = (lib.genList (x: "/dev/hidraw${toString x}") 13) ++ [
          "/dev/input"
          "/dev/uinput"
        ];
      };

      prismlauncher = {
        applications = [ pkgs.prismlauncher ];
        allowDesktop = true;
        allowX11 = true;
        unshareNet = false;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        applications = [ pkgs.heroic ];
        allowDesktop = true;
        allowX11 = true;
        unshareNet = false;
        persistentHome = true;
        extraBinds = [
          "/run/media/moritz/games/Heroic"
          "/sys/class/input"
        ];
        extraDevBinds = [
          "/dev/input"
          "/dev/uinput"
        ];
      };

      dolphin-emu = {
        applications = [ pkgs.dolphin-emu ];
        allowDesktop = true;
        allowX11 = true;
        extraBinds = [
          "$HOME/.config/dolphin-emu"
          "$HOME/.local/share/dolphin-emu"
          "$HOME/.cache/dolphin-emu"
        ];
        extraRoBinds = [
          "/run/media/moritz/games/wii"
          "/run/media/moritz/games/gc"
        ];
        extraDevBinds = [
          "/dev/input"
          "/dev/uinput"
        ];
      };

      rpcs3 = {
        applications = [ pkgs.rpcs3 ];
        allowDesktop = true;
        extraBinds = [
          "$HOME/.config/rpcs3"
          "$HOME/.cache/rpcs3"
        ];
        extraRoBinds = [ "/run/media/moritz/games/ps3" ];
        extraDevBinds = [
          "/dev/input"
          "/dev/uinput"
        ];
      };
    };
  };
}
