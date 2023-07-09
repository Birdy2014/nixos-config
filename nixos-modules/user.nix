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

  # Useful for audio stuff, podman and RPCS3
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Performance-tuning
  security.pam.loginLimits = [
    {
      domain = "moritz";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "moritz";
      item = "rtprio";
      type = "-";
      value = "95";
    }
    {
      domain = "moritz";
      item = "nice";
      type = "-";
      value = "-19";
    }
    {
      domain = "moritz";
      item = "nproc";
      type = "-";
      value = "unlimited";
    }
  ];

}
