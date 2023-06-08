{ pkgs, ... }:

{
  users.users.moritz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "i2c" ];
    shell = pkgs.zsh;
    home = "/home/moritz";
    createHome = true;
  };

  programs.zsh.enable = true;
}
