{
  config,
  pkgs,
  pkgsSelf,
  ...
}:

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
    sshfs
    ldns # for drill
    binutils # for strings
    nix-tree
    htop
    fd
    jq

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

  security.sudo.extraConfig = ''
    Defaults env_keep += "EDITOR"
  '';

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
