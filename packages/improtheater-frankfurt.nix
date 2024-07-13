{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-07-13";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "435853cb049205a273082d72430a920be6dee48b";
    hash = "sha256-fETMPgBRX/COLwJkTlr1ZafaN38ntZOlbUcNQmaVcg0=";
  };

  npmDepsHash = "sha256-C08wQ7/rJnUE8ukJdIaD4zkPNIQMlPwfmMjexpo+R9M=";

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
