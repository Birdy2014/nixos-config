{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-09-18";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "9951df65fd9dc0c6e388612ff53bef8743863fac";
    hash = "sha256-pigO/hnKuRUS5eZnCce40Mcwv0kwZxy+Dp9nGNiQIGA=";
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
