final: prev: {
  imv = prev.imv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.libwebp ];
    patches = (old.patches or [ ]) ++ [
      ./0001-Set-cursor-image-to-left_ptr.patch
      ./0002-Add-support-for-webp.patch
    ];
    mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
  });
}
