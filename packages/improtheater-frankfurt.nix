{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-08-12";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "62204a2e646346f1fa83b2461c90c67440ff783b";
    hash = "sha256-NMf6W4BEDASitrYr/ijeWAEevzpDe4ozbviM59NSbiM=";
  };

  npmDepsHash = "sha256-SNMuZhYmacT8yY4fZe5bQ+avVGS1iW816AlNWg+x4FQ=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
