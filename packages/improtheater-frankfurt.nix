{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-02-19";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "ed257e3512bcd56208cec48317a25dc5abc62617";
    hash = "sha256-RKoW8pC07vXn10auBQRoKwahAnyozLVm415ISdQqgCk=";
  };

  npmDepsHash = "sha256-Dv97SLbrF62hCUSBlbootlxVuAZk/I3Ry5+LtlOfWTE=";

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
