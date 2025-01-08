{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-01-08";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "8110670a28f4f920586c0f315c22e4600b3c7dd1";
    hash = "sha256-cFtYh/cxG8cFxcOFK+1HR29YXOMxPV0JqPEyP5tHR+M=";
  };

  npmDepsHash = "sha256-NNdutGaqVyQOaAU2MXq5Gsx4qXOEtH6FhFUy+jWRN2I=";

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
