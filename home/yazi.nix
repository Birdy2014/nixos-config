{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    plugins.smart-enter = pkgs.yaziPlugins.smart-enter;

    settings = {
      manager = {
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
      manager.prepend_keymap = [
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
      manager.append_keymap = [ ];
    };

    theme = {
      manager = {
        preview_hovered = {
          reversed = true;
          underline = false;
        };
        border_symbol = " ";
      };
      status = {
        separator_open = "█";
        separator_close = "█";
      };
    };
  };
}
