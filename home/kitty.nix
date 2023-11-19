{ ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "monospace";
      size = 10;
    };

    shellIntegration.mode = "disabled";

    settings = {
      disable_ligatures = "cursor";
      remember_window_size = false;
      initial_window_width = 720;
      initial_window_height = 480;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      kitty_mod = "ctrl+shift";
      clear_all_shortcuts = true;

      # Theme
      background = "#282828";
      foreground = "#ebdbb2";

      cursor = "#928374";

      selection_foreground = "#928374";
      selection_background = "#3c3836";

      color0 = "#282828";
      color8 = "#928374";

      # red
      color1 = "#cc241d";
      # light red
      color9 = "#fb4934";

      # green
      color2 = "#98971a";
      # light green
      color10 = "#b8bb26";

      # yellow
      color3 = "#d79921";
      # light yellow
      color11 = "#fabd2f";

      # blue
      color4 = "#458588";
      # light blue
      color12 = "#83a598";

      # magenta
      color5 = "#b16286";
      # light magenta
      color13 = "#d3869b";

      # cyan
      color6 = "#689d6a";
      # lighy cyan
      color14 = "#8ec07c";

      # light gray
      color7 = "#a89984";
      # dark gray
      color15 = "#928374";

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
