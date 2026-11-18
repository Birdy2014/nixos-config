{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-11-18";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "34c7e33920babe06780a166016c096ea53b2b524";
    hash = "sha256-cZ6okFs/Lv10S5WRrjG6lbeR2WXd1XswezOFNibJ5Lc=";
  };

  npmDepsHash = "sha256-wU7ZzA3od2LwqRNuFhEkiWxEbo0fWpRJtg7rPBjvaH0=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
