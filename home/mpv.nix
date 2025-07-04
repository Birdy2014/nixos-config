{
  lib,
  osConfig,
  pkgs,
  pkgsSelf,
  ...
}:

{
  programs.mpv =
    let
      enableExpensive = osConfig.my.home.mpv.enableExpensiveEffects;
      vapoursynthMvtoolsConfig = pkgs.writeText "mvtools.vpy" ''
        from vapoursynth import core

        clip = video_in

        dst_fps = container_fps * 2

        # Skip interpolation for 60 Hz content
        if not (container_fps > 59):
            src_fps_num = int(container_fps * 1e8)
            src_fps_den = int(1e8)
            dst_fps_num = int(dst_fps * 1e4)
            dst_fps_den = int(1e4)
            # Needed because clip FPS is missing
            clip = core.std.AssumeFPS(clip, fpsnum = src_fps_num, fpsden = src_fps_den)
            print("Reflowing from ",src_fps_num/src_fps_den," fps to ",dst_fps_num/dst_fps_den," fps.")

            sup  = core.mv.Super(clip, pel=1, hpad=8, vpad=8)
            bvec = core.mv.Analyse(sup, blksize=8, isb=True , chroma=True, search=3, searchparam=1)
            fvec = core.mv.Analyse(sup, blksize=8, isb=False, chroma=True, search=3, searchparam=1)
            clip = core.mv.BlockFPS(clip, sup, bvec, fvec, num=dst_fps_num, den=dst_fps_den, mode=3, thscd2=12)

        clip.set_output()
      '';
    in
    {
      enable = true;
      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          vapoursynthSupport = enableExpensive;
          vapoursynth = (pkgs.vapoursynth.withPlugins [ pkgs.vapoursynth-mvtools ]);
        };
        scripts = [
          pkgs.mpvScripts.mpris
          pkgs.mpvScripts.thumbfast
          pkgsSelf.mpv-thumbfast-vanilla-osc
        ];
      };
      config =
        {
          keep-open = true;
          script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
          autofit-larger = "100%x100%";
          hwdec = "auto-safe";
          vo = "gpu-next";
          osc = "no"; # Use thumbfast osc
          screenshot-format = "png";
          screenshot-template = "%F - [%P] (%#01n)";

          # Fix slow screenshots
          screenshot-high-bit-depth = "no";
          screenshot-png-compression = 5;

          # Languages
          alang = "jpn,eng,en,deu,de";

          # Subtitles
          demuxer-mkv-subtitle-preroll = "yes";
          sub-visibility = false;
          slang = "deu,de,enm,eng,en"; # enm is sometimes used for english with honorifics in anime
          sub-font-size = 40;
          sub-bold = true;
          sub-scale-with-window = false; # This is confusing, but seems to fix the wired behaviour when using panscan

          # HDR
          hdr-compute-peak = "no";
          tone-mapping = "bt.2446a";

          # Scaling
          scale = if enableExpensive then "ewa_lanczos4sharpest" else "lanczos";
          dscale = "hermite";
        }
        // lib.optionalAttrs enableExpensive {
          # Interpolation
          video-sync = "display-resample";
          interpolation = "yes";
          tscale = "triangle";

          # HDR
          hdr-compute-peak = "auto";
          allow-delayed-peak-detect = true;
        };

      bindings =
        {
          LEFT = "seek -5";
          RIGHT = "seek +5";

          h = "seek -5 exact";
          l = "seek +5 exact";
          H = "seek -1 exact";
          L = "seek +1 exact";

          WHEEL_UP = "ignore";
          WHEEL_DOWN = "ignore";
          WHEEL_LEFT = "ignore";
          WHEEL_RIGHT = "ignore";

          u = "cycle-values sub-ass-override force strip no";
          D = "cycle deband";
        }
        // lib.optionalAttrs enableExpensive {
          "Ctrl+i" =
            "vf toggle vapoursynth=${vapoursynthMvtoolsConfig}:buffered-frames=4:concurrent-frames=32";
        };
    };
}
