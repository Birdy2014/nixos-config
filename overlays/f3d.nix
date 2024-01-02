# Downgrade f3d to 2.1.0. See https://github.com/NixOS/nixpkgs/issues/262328

final: prev: {
  f3d = prev.f3d.overrideAttrs (old: rec {
    version = "2.1.0";

    src = final.fetchFromGitHub {
      owner = "f3d-app";
      repo = "f3d";
      rev = "refs/tags/v${version}";
      hash = "sha256-2LDHIeKgLUS2ujJUx2ZerXmZYB9rrT3PYvrtzV4vcHM=";
    };
  });
}
