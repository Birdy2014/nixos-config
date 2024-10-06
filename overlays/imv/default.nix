final: prev: {
  imv = (prev.imv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.libwebp ];
    src = prev.fetchFromGitHub {
      owner = "Birdy2014";
      repo = "imv";
      rev = "3534c3f62b72529dc751878005d206510aa8c0d1";
      hash = "sha256-fvlxUBkTEmr/vRAJ/Umc821rqqozsHRolHCoOyl1aNM=";
    };
    mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
  })).override {
    withBackends =
      [ "libjxl" "libtiff" "libjpeg" "libpng" "librsvg" "libheif" "libnsgif" ];
  };
}
