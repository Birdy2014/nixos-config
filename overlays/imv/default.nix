final: prev: {
  imv = (prev.imv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.libwebp ];
    patches = (old.patches or [ ]) ++ [
      ./0001-Set-cursor-image-to-left_ptr.patch
      ./0002-Add-support-for-webp.patch
      ./0003-Fix-distortion-in-heif-and-avif.patch
      ./0004-Add-qoi-backend.patch
      ./0005-Update-libnsgif-support-for-libnsgif-1.0.0.patch
    ];
    mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
  })).override {
    withBackends =
      [ "libjxl" "libtiff" "libjpeg" "libpng" "librsvg" "libheif" "libnsgif" ];
  };
}
