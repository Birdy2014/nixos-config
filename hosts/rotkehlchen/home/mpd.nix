{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    network.listenAddress = "any";
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
    mpd.host = "127.0.0.1";
  };

  programs.ncmpcpp = {
    enable = true;
    package = (pkgs.ncmpcpp.overrideAttrs (old: {
      # Use a git version because the tag editor is broken for opus in 0.9.2
      src = pkgs.fetchFromGitHub {
        owner = "ncmpcpp";
        repo = "ncmpcpp";
        rev = "81e5cf58b44be4ec0dc50722e2ed6d534df3973d";
        hash = "sha256-fSy5CMrVhU48iu7H4fxXtNrxXHMtH1k0gizk00z7CgA=";
      };

      preConfigure = ''
        ./autogen.sh
      '';

      nativeBuildInputs = old.nativeBuildInputs
        ++ (with pkgs; [ autoconf automake libtool m4 ]);

      buildInputs = old.buildInputs ++ [ pkgs.opusfile ];
    })).override { visualizerSupport = true; };

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
