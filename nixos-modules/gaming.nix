{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable =
    lib.mkEnableOption (lib.mdDoc "Whether to enable gaming related programs.");

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          [
            # Some (Unity) games require the corefonts to be in /usr/share/fonts
            (pkgs.runCommand "share-fonts" { preferLocalBuild = true; } ''
              mkdir -p "$out/share/fonts"
              ln -s ${pkgs.corefonts}/share/fonts/* $out/share/fonts
            '')
          ];
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      # Launchers
      heroic
      prismlauncher
      (lutris.override { extraPkgs = pkgs: [ wineWowPackages.stable ]; })

      # Emulators
      yuzu-mainline
      dolphin-emu
      pcsx2
      rpcs3

      # Tools
      mangohud
    ];

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
