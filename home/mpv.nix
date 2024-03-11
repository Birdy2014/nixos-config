{ inputs, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = [
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.thumbfast
      inputs.self.packages.${pkgs.system}.mpv-thumbfast-vanilla-osc
    ];
    config = {
      keep-open = true;
      script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
      autofit-larger = "100%x100%";
      hwdec = "auto-safe";
      vo = "gpu-next";
      osc = "no"; # Use thumbfast osc

      # Languages
      alang = "jpn,eng,en,deu,de";

      # Subtitles
      demuxer-mkv-subtitle-preroll = "yes";
      sub-visibility = false;
      slang = "deu,de,eng,en";

      # Prevent framedrops on HDR Videos
      hdr-compute-peak = "no";

      # Scaling
      scale = "ewa_lanczos4sharpest";
      dscale = "hermite";
      cscale = "ewa_lanczos4sharpest";

      # Interpolation
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "mitchell";
    };

    bindings = {
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

      # Anime4k
      "CTRL+1" =
        "no-osd change-list glsl-shaders set '${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl'; show-text 'Anime4K: Mode A (HQ)'";
      "CTRL+2" =
        "no-osd change-list glsl-shaders set '${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl'; show-text 'Anime4K: Mode B (HQ)'";
      "CTRL+3" =
        "no-osd change-list glsl-shaders set '${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl'; show-text 'Anime4K: Mode C (HQ)'";

      "CTRL+0" =
        "no-osd change-list glsl-shaders clr ''; show-text 'GLSL shaders cleared'";

      a = "cycle-values sub-ass-override strip no";
      D = "cycle deband";
    };
  };
}
