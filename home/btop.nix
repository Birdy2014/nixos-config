{ config, inputs, myLib, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      # general
      color_theme = "custom";
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

  xdg.configFile."btop/themes/custom.theme".text = let
    colorizer = inputs.nix-colorizer;
    mix = hex1: hex2: ratio:
      colorizer.oklchToHex
      (myLib.mix (colorizer.hexToOklch hex1) (colorizer.hexToOklch hex2) ratio);
  in with config.my.theme; ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="${background-secondary}"

    # Main text color
    theme[main_fg]="${text}"

    # Title color for boxes
    theme[title]="${text}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${blue}"

    # Background color of selected item in processes box
    theme[selected_bg]="${black}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="${blue}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${text-inactive}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#f2d5cf"

    # Background color of the percentage meters
    theme[meter_bg]="${black}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#f2d5cf"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="${magenta}"
    theme[mem_box]="${green}"
    theme[net_box]="${yellow}"
    theme[proc_box]="${blue}"

    # Box divider line and small boxes line color
    theme[div_line]="${text-inactive}"

    # Temperature graph color
    theme[temp_start]="${green}"
    theme[temp_mid]="${yellow}"
    theme[temp_end]="${red}"

    # CPU graph colors
    theme[cpu_start]="${cyan}"
    #theme[cpu_mid]="${yellow}"
    theme[cpu_end]="${red}"

    # Mem/Disk free meter
    theme[free_start]="${magenta}"
    #theme[free_mid]="${mix magenta blue 0.5}"
    theme[free_end]="${blue}"

    # Mem/Disk cached meter
    theme[cached_start]="${cyan}"
    theme[cached_mid]="${mix cyan blue 0.5}"
    theme[cached_end]="${blue}"

    # Mem/Disk available meter
    theme[available_start]="${yellow}"
    theme[available_mid]="${mix yellow red 0.5}"
    theme[available_end]="${red}"

    # Mem/Disk used meter
    theme[used_start]="${green}"
    theme[used_mid]="${cyan}"
    theme[used_end]="${light-cyan}"

    # Download graph colors
    theme[download_start]="${yellow}"
    theme[download_mid]="${mix yellow red 0.5}"
    theme[download_end]="${red}"

    # Upload graph colors
    theme[upload_start]="${green}"
    theme[upload_mid]="${cyan}"
    theme[upload_end]="${light-cyan}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${cyan}"
    theme[process_mid]="${mix cyan magenta 0.5}"
    theme[process_end]="${magenta}"
  '';
}
