{
  osConfig,
  pkgs,
  pkgsSelf,
  ...
}:

{
  services.gnome-keyring.enable = true;

  nix.gc = {
    inherit (osConfig.nix.gc) automatic dates options;
  };

  home.packages = with pkgs; [
    # CLI
    cifs-utils
    unzip
    _7zz
    zip
    alsa-utils
    trash-cli
    progress
    ffmpeg
    libqalculate
    bashmount
    pkgsSelf.playerctl-current
    gdb
    kiwix-tools
    pciutils
    usbutils
    sshfs
    jq
    pkgs.steam.run-free

    # GUI
    pavucontrol
    crosspipe
    obsidian
    zathura
    neovide
    hotspot
    libreoffice
    thunderbird
    element-desktop
    kiwix
    zotero

    (pkgs.runCommand "foliate" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      makeWrapper ${lib.getExe pkgs.foliate} $out/bin/foliate \
        --set GDK_BACKEND x11
    '')
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de-nodeadkeys";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-de-nodeadkeys";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          "GroupOrder"."0" = "Default";
        };
        # The F13 key is called "Tools" for some reason
        globalOptions."Hotkey/TriggerKeys"."0" = "Tools";
      };
    };
  };
}
