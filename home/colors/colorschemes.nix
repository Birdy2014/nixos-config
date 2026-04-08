{ osConfig, ... }:

# colorschemes to maybe add:
# - onedark light
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

        onedark-dark = rec {
          accent = "#d19a66";
          accent-text = "#000000";
          accent-complementary = blue;

          background-primary = "#393f4a";
          background-secondary = "#282c34";
          background-tertiary = "#21252b";
          text = "#abb2bf";
          text-inactive = light-black;

          black = "#181a1f";
          light-black = "#5c6370";

          red = "#e86671";
          green = "#98c379";
          yellow = "#e5c07b";
          blue = "#61afef";
          magenta = "#c678dd";
          cyan = "#56b6c2";
          white = "#ebd09c";
        };

        onedark-darker = rec {
          accent = "#cc9057";
          accent-text = "#000000";
          accent-complementary = blue;

          background-primary = "#30363f";
          background-secondary = "#282c34";
          background-tertiary = "#1f2329";
          text = "#a0a8b7";
          text-inactive = light-black;

          black = "#0e1013";
          light-black = "#535965";

          red = "#e55561";
          green = "#8ebd6b";
          yellow = "#e2b86b";
          blue = "#4fa6ed";
          magenta = "#bf68d9";
          cyan = "#48b0bd";
          white = "#e8c88c";
        };
      };
    in
    colorschemes.${osConfig.my.desktop.colorscheme};
}
