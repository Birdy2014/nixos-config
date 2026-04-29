{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_24,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-04-29";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "263c43d5768da09669df5e8fad704d55068b3e8c";
    hash = "sha256-UXtMkU2ZxaItrGXYvxHwYYGUg58iiwvQouzg5GNs1CQ=";
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
