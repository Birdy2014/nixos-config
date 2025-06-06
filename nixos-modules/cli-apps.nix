{ config, lib, pkgs, pkgsSelf, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgsSelf.neovim.override {
      colorscheme = config.my.desktop.colorscheme;
      withLanguageServers = config.my.desktop.enable;
    })
    ripgrep
    git
    file
    psmisc
    socat
    pciutils
    usbutils
    compsize
    # keyutils # Brauche ich das?
    sshfs
    ldns # for drill
    binutils # for strings
    nix-tree
    htop
    fd

    man-pages
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.command-not-found.enable = false;

  documentation = {
    info.enable = false;
    dev.enable = true;
  };

  security.pam.services.systemd-run0.enable = true;

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];

  xdg = lib.mkIf (!config.my.desktop.enable) {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };
}
