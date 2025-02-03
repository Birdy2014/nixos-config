{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-02-03";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "fed6ee8ff72461644bf0bfcfb9d46852952b6ee2";
    hash = "sha256-5XLtyXWqSiflywcfd+jleC+fx6L79OL3vrNSXdGhI2s=";
  };

  npmDepsHash = "sha256-Xnl8b5c3OQalmKIaUK3RRMVd2tthMV7TrmJvvpAlAI4=";

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
