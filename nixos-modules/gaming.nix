{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable =
    lib.mkEnableOption (lib.mdDoc "gaming related programs");

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
