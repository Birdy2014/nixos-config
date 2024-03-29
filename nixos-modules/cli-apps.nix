{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.self.packages.${pkgs.system}.neovim
    ripgrep
    git
    file
    tmux
    psmisc
    libqalculate
    unrar
    unzip
    _7zz
    zip
    yt-dlp
    socat
    nil # nix language server
    neofetch
    pciutils
    usbutils
    alsaUtils
    compsize
    trash-cli
    ffmpeg
    cifs-utils
    keyutils
    sshfs
    bashmount
    ldns # for drill
    binutils # for strings
    progress
    waypipe
    nix-tree

    inputs.self.packages.${pkgs.system}.xdg-open
    inputs.self.packages.${pkgs.system}.playerctl-current
  ];

  services.udisks2.enable = true;

  documentation.man.enable = true;
  documentation.nixos.includeAllModules = true;

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
