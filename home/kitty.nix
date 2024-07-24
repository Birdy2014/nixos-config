{ config, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "monospace";
      size = 10;
    };

    shellIntegration.mode = "disabled";

    settings = with config.my.theme; {
      disable_ligatures = "cursor";
      remember_window_size = false;
      initial_window_width = 720;
      initial_window_height = 480;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      kitty_mod = "ctrl+shift";
      clear_all_shortcuts = true;

      # Theme
      background = background-secondary;
      foreground = text;

      cursor = light-white;

      selection_foreground = text-inactive;
      selection_background = background-primary;

      color0 = black;
      color1 = red;
      color2 = green;
      color3 = yellow;
      color4 = blue;
      color5 = magenta;
      color6 = cyan;
      color7 = white;
      color8 = light-black;
      color9 = light-red;
      color10 = light-green;
      color11 = light-yellow;
      color12 = light-blue;
      color13 = light-magenta;
      color14 = light-cyan;
      color15 = light-white;
    };

    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+y" = "paste_from_selection";
      "kitty_mod+v" = "paste_from_clipboard";

      "kitty_mod+page_up" = "change_font_size all +1.0";
      "kitty_mod+page_down" = "change_font_size all -1.0";
    };
  };
}
