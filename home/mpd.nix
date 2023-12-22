{ config, lib, osConfig, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    network.listenAddress =
      lib.mkIf osConfig.my.home.mpdListenExternal "0.0.0.0";
    extraConfig = ''
      audio_output {
        type   "pipewire"
        name   "PipeWire Sound Server"
      }

      audio_output {
        type   "fifo"
        name   "my_fifo"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  services.mpdris2 = {
    enable = true;
    notifications = true;
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    bindings = [
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "J";
        command = [ "select_item" "scroll_down" ];
      }
      {
        key = "K";
        command = [ "select_item" "scroll_up" ];
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
    ];
    settings = {
      startup_screen = "media_library";

      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "●█";
      visualizer_spectrum_smooth_look = "yes";
      visualizer_spectrum_dft_size = 1;

      progressbar_look = "━━─";

      empty_tag_color = "magenta";

      media_library_primary_tag = "album_artist";
      media_library_albums_split_by_date = "no";

      playlist_display_mode = "columns";
      browser_display_mode = "columns";
    };
  };
}
