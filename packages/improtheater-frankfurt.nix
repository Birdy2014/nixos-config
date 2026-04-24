{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_20,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-04-24";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "b0599467bac763608585949b73f142dea7ee9a86";
    hash = "sha256-YjWnRKwGxBkAZAmHv2d44A8DKopfruycT1PfLi4guqc=";
  };

  npmDepsHash = "sha256-4UjAVYqxd6puWYDCMVAiVQMCb51ihR3wirpgVLEoIzI=";

  nativeBuildInputs = [
    # for sharp
    nodePackages.node-gyp
  ];

  nodejs = nodejs_20;

  # Reduce closure size
  postInstall = ''
    prefix="$out/lib/node_modules/improtheater-frankfurt/node_modules"
    rm $prefix/better-sqlite3/build/Makefile
    rm $prefix/better-sqlite3/build/config.gypi
    rm $prefix/better-sqlite3/build/better_sqlite3.target.mk
    rm $prefix/better-sqlite3/build/test_extension.target.mk
    rm -r $prefix/better-sqlite3/build/deps
    rm -r $prefix/better-sqlite3/build/Release/.deps
  '';

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
