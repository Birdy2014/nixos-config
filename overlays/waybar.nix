# TODO: Remove when waybar 0.10.1 is released

final: prev: {
  waybar = prev.waybar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (final.fetchpatch {
        url =
          "https://github.com/Alexays/Waybar/commit/2ffd9a94a505a2e7e933ea8303f9cf2af33c35fe.diff";
        hash = "sha256-u87t6zzslk1mzSfi4HQ6zDPFr7qMfsvymTy3HBxVTJQ=";
      })
    ];
  });
}
