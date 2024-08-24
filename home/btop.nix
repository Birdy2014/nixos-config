{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      # general
      color_theme = "gruvbox_dark";
      theme_background = true;
      truecolor = true;
      force_tty = false;
      vim_keys = true;
      graph_symbold = "braille";
      update_ms = 500;

      # mem
      swap_disk = false;

      # disks
      use_fstab = false;
      disks_filter =
        "/ /boot /run/media/moritz/archive /run/media/moritz/games";

      # proc
      proc_per_core = true;
    };
  };
}
