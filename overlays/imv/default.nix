final: prev: {
  imv = prev.imv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.libwebp ];
    patches = (old.patches or [ ]) ++ [
      ./0001-Set-cursor-image-to-left_ptr.patch
      ./0002-Add-support-for-webp.patch
      ./0003-Fix-distortion-in-heif-and-avif.patch
      ./0004-Add-qoi-backend.patch
    ];
    mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
  });
}
