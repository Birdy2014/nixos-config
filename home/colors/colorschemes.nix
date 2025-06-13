{ osConfig, ... }:

# colorschemes to maybe add:
# - onedark
# - tokyo night

{
  my.theme =
    let
      colorschemes = {
        gruvbox-material-dark = rec {
          accent = yellow;
          accent-text = "#000000";
          accent-background = "#a96b2c";
          accent-complementary = cyan;

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

        gruvbox-material-light = rec {
          isLight = true;

          accent = yellow;
          accent-text = "#000000";
          #accent-background = "#a96b2c";
          accent-complementary = cyan;

          background-primary = "#ebdbb2";
          background-secondary = "#fbf1c7";
          background-tertiary = "#f9f5d7";

          text = "#282828";
          text-inactive = "#3c3836";

          black = "#fbf1c7";
          light-black = "#928374";

          red = "#cc241d";
          light-red = "#9d0006";

          green = "#98971a";
          light-green = "#79740e";

          yellow = "#d79921";
          light-yellow = "#b57614";

          blue = "#458588";
          light-blue = "#076678";

          magenta = "#b16286";
          light-magenta = "#8f3f71";

          cyan = "#689d6a";
          light-cyan = "#427b58";

          white = "#7c6f64";
          light-white = "#3c3836";
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

        catppuccin-latte = rec {
          isLight = true;

          accent = green;
          accent-text = "#ffffff";
          accent-complementary = "#8839ef";

          background-primary = "#eff1f5";
          background-secondary = "#e6e9ef";
          background-tertiary = "#dce0e8";
          text = "#4c4f69";
          text-inactive = "#6c6f85";

          black = "#bcc0cc";
          light-black = "#acb0be";

          red = "#d20f39";
          green = "#40a02b";
          yellow = "#df8e1d";
          blue = "#1e66f5";
          magenta = "#ea76cb";
          cyan = "#179299";
          white = "#5c5f77";
          light-white = "#5c5f77";
        };
      };
    in
    colorschemes.${osConfig.my.desktop.colorscheme};
}
