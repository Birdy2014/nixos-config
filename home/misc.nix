{
  osConfig,
  pkgs,
  pkgsSelf,
  ...
}:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  nix.gc = {
    inherit (osConfig.nix.gc) automatic dates options;
  };

  home.packages = with pkgs; [
    # CLI
    cifs-utils
    libarchive
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
    pkgsSelf.wine-sandbox
    kiwix-tools
    socat
    pciutils
    usbutils
    sshfs
    binutils # for strings
    jq

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
  ];

  my.bubblewrap.foliate = {
    applications = [ pkgs.foliate ];
    allowDesktop = true;
    allowX11 = true;
    extraBinds = [
      "$HOME/.local/share/com.github.johnfactotum.Foliate"
      "$HOME/.cache/com.github.johnfactotum.Foliate"
    ];
    extraRoBinds = [ "/run/media/moritz/archive/Archiv/Bücher" ];
    # foliate seems to be broken on niri/wayland
    extraEnv.GDK_BACKEND = "x11";
  };

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
