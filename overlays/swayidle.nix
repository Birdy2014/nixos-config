final: prev: {
  swayidle = prev.swayidle.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Required for next patch, remove when next swayidle version (after 1.8.0) is released
      (final.fetchpatch {
        url =
          "https://github.com/swaywm/swayidle/commit/61d653fb7a752910f71efb3e7d08d75b266cf3ea.diff";
        hash = "sha256-wwe4WxT8t1VLjyVSpYrAahehvpB21TmhA7f6tkgtGqg=";
      })

      # https://github.com/swaywm/swayidle/pull/164
      (final.fetchpatch {
        url =
          "https://github.com/swaywm/swayidle/commit/d12f7e622c5aff6e7093e9ce6f2fcb7e7d56ee3c.diff";
        hash = "sha256-aQLw6FBWd7ccoybtIl2obh0jNYK/9LMUVLRmgZ66RAo=";
      })
    ];
  });
}
