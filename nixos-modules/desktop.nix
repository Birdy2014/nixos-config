{ config, pkgs, ... }:

{
  hardware.opengl.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.dconf.enable = true;

  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.moritz.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = "*";
      sway.default = [ "wlr" "gtk" ];
    };
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;

      defaultFonts.serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP" ];
      defaultFonts.sansSerif = [ "NotoSans Nerd Font" "Noto Sans CJK JP" ];
      defaultFonts.monospace =
        [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      defaultFonts.emoji = [ "Noto Color Emoji" ];
    };

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Noto" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      corefonts
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };

  services.syncthing = {
    enable = true;
    user = "moritz";
    group = "users";
    overrideFolders = false;
    overrideDevices = false;
    configDir = "${config.users.users.moritz.home}/.config/syncthing";
    dataDir = "${config.users.users.moritz.home}/.local/state/syncthing";
  };
}
