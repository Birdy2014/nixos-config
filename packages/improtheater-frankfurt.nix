{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_24,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-05-12";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "62b8bb45b581a6180130960358f90063898b0a14";
    hash = "sha256-zpRoeUz5/esvRd8okX9zFVwKN5FsIv2fIBffrPUMHzo=";
  };

  npmDepsHash = "sha256-4UjAVYqxd6puWYDCMVAiVQMCb51ihR3wirpgVLEoIzI=";

  nativeBuildInputs = [
    # for sharp
    nodePackages.node-gyp
  ];

  nodejs = nodejs_24;

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
