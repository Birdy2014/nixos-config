{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    plugins.smart-enter = pkgs.yaziPlugins.smart-enter;

    settings = {
      mgr = {
        ratio = [
          2
          4
          6
        ];
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        max_width = 1280;
        max_height = 720;
        image_filter = "lanczos3";
        cache_dir = "$XDG_CACHE_HOME/yazi_images";
      };
      opener.play = [
        {
          run = ''xdg-open "$@"'';
          desc = "Open";
          for = "linux";
        }
      ];
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "cd /run/media/$USER";
          desc = "Go to the media directory";
        }
        {
          on = [ "<C-n>" ];
          run = ''
            shell '${pkgs.ripdrag}/bin/ripdrag -x "$1"' --confirm
          '';
        }
      ];
      mgr.append_keymap = [ ];
    };

    theme =
      let
        inherit (config.my) theme;

        symbols = {
          open = "█";
          close = "█";
        };
      in
      {
        mgr = {
          preview_hovered = {
            reversed = true;
            underline = false;
          };
          border_symbol = " ";
        };
        status = {
          sep_left = symbols;
          sep_right = symbols;
        };
        tabs = {
          sep_inner = symbols;
          sep_outer = symbols;
        };

        mode = {
          # Normal mode
          normal_main = {
            fg = theme.background-primary;
            bg = "blue";
            bold = true;
          };
          normal_alt = {
            fg = "blue";
            bg = "black";
          };
          # Select mode
          select_main = {
            fg = theme.background-primary;
            bg = "green";
            bold = true;
          };
          select_alt = {
            fg = "green";
            bg = "black";
          };
          # Unset mode
          unset_main = {
            fg = theme.background-primary;
            bg = "magenta";
            bold = true;
          };
          unset_alt = {
            fg = "magenta";
            bg = "black";
          };
        };
      };
  };
}
