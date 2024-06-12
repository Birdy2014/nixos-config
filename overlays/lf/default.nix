final: prev: {
  lf = prev.lf.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./0001-Show-dirsize-if-dircounts-is-enabled.patch
      ./0002-Add-file-path-to-exec-in-desktop-file.patch
    ];
  });
}
