{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-04-16";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "9c77b182caef981c236ed9f90d77f881f7db39b4";
    hash = "sha256-Wu+67T8UuYfuI7oBrWa0udj8hEgdJ2fZPW05zAgtTFo=";
  };

  npmDepsHash = "sha256-Eq8KWm3/dlv78CQZ3CJcThKHe4YUwH3rxgfd2u731EI=";

  nativeBuildInputs = [
    # for bcrypt
    nodePackages.node-pre-gyp

    # for sharp
    pkg-config
  ];

  buildInputs = [
    # for sharp
    vips
  ];

  nodejs = nodejs_20;

  dontNpmBuild = true;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
