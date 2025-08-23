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
          accent-text = "#ffffff";
          accent-complementary = cyan;

          background-primary = "#f9f5d7";
          background-secondary = "#fbf1c7";
          # background-tertiary = "#ebdbb2";
          background-tertiary = "#ddccab";

          text = "#282828";
          text-inactive = "#3c3836";

          black = "#fbf1c7";
          light-black = "#928374";

          red = "#9d0006";
          light-red = "#cc241d";

          green = "#79740e";
          light-green = "#98971a";

          yellow = "#b57614";
          light-yellow = "#d79921";

          blue = "#076678";
          light-blue = "#458588";

          magenta = "#8f3f71";
          light-magenta = "#b16286";

          cyan = "#427b58";
          light-cyan = "#689d6a";

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

        kanso-mist = rec {
          accent = green;
          accent-text = "#000000";

          background-primary = "#393B44";
          background-secondary = "#2a2c35";
          background-tertiary = "#22262D";
          text = "#f2f1ef";
          text-inactive = "#C5C9C7";

          black = "#22262d";
          light-black = "#5C6066";

          red = "#c4746e";
          light-red = "#e46876";

          green = "#8a9a7b";
          light-green = "#87a987";

          yellow = "#c4b28a";
          light-yellow = "#e6c384";

          blue = "#8ba4b0";
          light-blue = "#7fb4ca";

          magenta = "#a292a3";
          light-magenta = "#938aa9";

          cyan = "#8ea4a2";
          light-cyan = "#7aa89f";

          white = "#a4a7a4";
          light-white = "#C5C9C7";
        };

        kanso-pearl = rec {
          isLight = true;

          accent = light-green;
          accent-text = "#ffffff";
          accent-complementary = blue;

          background-primary = "#f2f1ef";
          background-secondary = "#e2e1df";
          background-tertiary = "#dddddb";
          text = black;
          text-inactive = "#545464";

          black = "#14171d";
          light-black = "#8a8980";

          red = "#D72436";
          light-red = "#E42D2C";

          green = "#5E8F2F";
          light-green = "#5B9945";

          yellow = "#656720";
          light-yellow = "#72612B";

          blue = "#2A73B1";
          light-blue = "#469FD3";

          magenta = "#C04062";
          light-magenta = "#44418F";

          cyan = "#3E8366";
          light-cyan = "#428F6A";

          white = "#545464";
          light-white = "#43436c";
        };
      };
    in
    colorschemes.${osConfig.my.desktop.colorscheme};
}
