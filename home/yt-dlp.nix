{ ... }:

{
  programs.yt-dlp = {
    enable = true;
    settings = {
      format = "bestvideo*[height<=1080]+bestaudio/best";
      embed-thumbnail = true;
      embed-metadata = true;
      embed-subs = true;
      embed-chapters = true;
      convert-thumbnails = "webp>jpg";
      merge-output-format = "mkv";
      compat-options = "no-live-chat";
      output = "'%(playlist_index&{} |)s%(title)s [%(id)s].%(ext)s'";
    };
  };
}
