final: prev: {
  lf = prev.lf.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (prev.fetchpatch {
        url = "https://github.com/gokcehan/lf/commit/78b2866a7b371ed807de9e6471a3a7343178337b.patch";
        hash = "sha256-9E8NTOibfbuH75huQlhAEqID7DrM6cMFjFzMURHHfao=";
      })
      ./0001-Show-dirsize-if-dircounts-is-enabled.patch
      ./0002-Add-file-path-to-exec-in-desktop-file.patch
      ./0003-show-file-sizes-in-copy-progress.patch
    ];
  });
}
