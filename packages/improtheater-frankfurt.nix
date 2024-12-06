{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2024-12-06";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "38223b6cb04fc2bec2a9a275bd6e8546dfcf8308";
    hash = "sha256-KWKOSmJuSMxjC2zErkz+lh/BY1XmZxGECo1aMLmj65M=";
  };

  npmDepsHash = "sha256-JxjOsvqeEJd3ygQd6rqwqs6Icxspy1j7Lq6YDMuT//4=";

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
