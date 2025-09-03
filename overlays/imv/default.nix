final: prev: {
  imv =
    (prev.imv.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ prev.libwebp ];
      src = prev.fetchFromGitHub {
        owner = "Birdy2014";
        repo = "imv";
        rev = "3af0fdda375226718d11396e6df93393d57812b2";
        hash = "sha256-EIqW8KRolDMF2Xo4Zv3Xfh9KYL7mHVIrbi80XtNdo8A=";
      };
      mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
      patches = [ ];
    })).override
      {
        withBackends = [
          "libjxl"
          "libtiff"
          "libjpeg"
          "libpng"
          "librsvg"
          "libheif"
          "libnsgif"
        ];
      };
}
