{ pkgs, ... }:

{
  my.bubblewrap = {
    spotify = {
      applications = [ pkgs.spotify ];
      allowDesktop = true;
      unshareNet = false;
      extraBinds = [
        "$HOME/.config/spotify"
        "$HOME/.cache/spotify"
      ];
    };

    vesktop = {
      applications = [ pkgs.vesktop ];
      allowDesktop = true;
      unshareNet = false;
      extraBinds = [
        "$HOME/.config/vesktop"
      ];
      extraRoBinds = [
        # Needed to be able to share files in the home directory
        "$HOME"
      ];
    };
  };
}
