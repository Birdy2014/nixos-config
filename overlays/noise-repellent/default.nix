final: prev: {
  noise-repellent = prev.noise-repellent.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "lucianodato";
      repo = "noise-repellent";
      rev = "6f2d6074fcf7c599450369c4f2132c2ce097a422";
      hash = "sha256-d8csYC3z3vXdmN/G6mAK+H8ia0vOCsoUpoA3W8/OADc=";
    };

    patches = (old.patches or []) ++ [
      ./fix-loading-noise-profile-carla.patch
    ];
  });
}
