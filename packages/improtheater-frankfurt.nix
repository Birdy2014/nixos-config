{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_20,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-12-13";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "e1288fa8d8e47e9f5097ae4f4f2581d4b4c301cc";
    hash = "sha256-KpKze0v2Ph6oCBfS5hXywv21VyDYfyHk7DMbNlqTXLg=";
  };

  npmDepsHash = "sha256-OmU8pRmYrHXv6FeVqh17wAdqWtu8PkD7fhXLDUD9yuk=";

  nativeBuildInputs = [
    # for sharp
    nodePackages.node-gyp
  ];

  nodejs = nodejs_20;

  dontNpmBuild = true;

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
