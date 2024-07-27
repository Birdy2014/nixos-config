{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ corefonts ];
      remotePlay.openFirewall = true;
    };

    my.bubblewrap = {
      steam = {
        executable = "${pkgs.steam}/bin/steam";
        desktop = "${pkgs.steam}/share/applications/steam.desktop";
        home = "$HOME/.local/share/steam";
        allowDesktop = true;
        extraBinds = [
          "/run/media/moritz/games/Steam-Linux"
          "/run/media/moritz/games/Steam-Images"
          "/sys/class/input"
        ];
        extraDevBinds = (lib.genList (x: "/dev/hidraw${toString x}") 13)
          ++ [ "/dev/input" "/dev/uinput" ];
      };

      prismlauncher = {
        executable = "${pkgs.prismlauncher}/bin/prismlauncher";
        desktop =
          "${pkgs.prismlauncher}/share/applications/org.prismlauncher.PrismLauncher.desktop";
        allowDesktop = true;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };
    };

    environment.systemPackages = with pkgs; [
      # Launchers
      heroic
      prismlauncher
      (lutris.override { extraPkgs = pkgs: [ wineWowPackages.stable ]; })

      # Emulators
      dolphin-emu
      rpcs3

      # Tools
      mangohud
    ];

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
