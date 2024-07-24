{ ... }:

{
  my.theme = let
    gruvbox = rec {
      accent = yellow;
      accent-text = "#000000";
      accent-background = "#a96b2c";
      accent-complementary = blue;

      background-primary = "#383838";
      background-secondary = "#282828";
      background-tertiary = "#1d2021";

      text = "#ebdbb2";
      text-inactive = "#ddc7a1";

      black = "#282828";
      light-black = "#928374";

      red = "#cc241d";
      light-red = "#fb4934";

      green = "#98971a";
      light-green = "#b8bb26";

      yellow = "#d79921";
      light-yellow = "#fabd2f";

      blue = "#458588";
      light-blue = "#83a598";

      magenta = "#b16286";
      light-magenta = "#d3869b";

      cyan = "#689d6a";
      light-cyan = "#8ec07c";

      white = "#a89984";
      light-white = "#928374";
    };

    catppuccin-macchiato = rec {
      accent = green;
      accent-text = "#000000";
      accent-complementary = "#c6a0f6";

      background-primary = "#24273a";
      background-secondary = "#1e2030";
      background-tertiary = "#181926";

      text = "#cad3f5";
      text-inactive = "#a5adcb";

      black = "#494d64";
      light-black = "#5b6078";

      red = "#ed8796";
      green = "#a6da95";
      yellow = "#eed49f";
      blue = "#8aadf4";
      magenta = "#f5bde6";
      cyan = "#8bd5ca";
      white = "#b8c0e0";
      light-white = "#b8c0e0";
    };

    catppuccin-frappe = rec {
      accent = green;
      accent-text = "#000000";
      accent-complementary = "#ca9ee6";

      background-primary = "#303446";
      background-secondary = "#292c3c";
      background-tertiary = "#232634";
      text = "#c6d0f5";
      text-inactive = "#a5adce";

      black = "#51576d";
      light-black = "#626880";

      red = "#e78284";
      green = "#a6d189";
      yellow = "#e5c890";
      blue = "#8caaee";
      magenta = "#f4b8e4";
      cyan = "#81c8be";
      white = "#b5bfe2";
      light-white = "#b5bfe2";
    };
  in catppuccin-frappe;
}
