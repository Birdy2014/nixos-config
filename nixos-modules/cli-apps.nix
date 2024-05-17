{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.self.packages.${pkgs.system}.neovim
    ripgrep
    git
    file
    psmisc
    unrar
    unzip
    _7zz
    zip
    socat
    pciutils
    usbutils
    alsaUtils
    compsize
    trash-cli
    ffmpeg
    cifs-utils
    keyutils
    sshfs
    ldns # for drill
    binutils # for strings
    progress
    waypipe
    nix-tree
  ];

  services.udisks2.enable = true;

  documentation.info.enable = false;
  documentation.nixos.includeAllModules = true;

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
