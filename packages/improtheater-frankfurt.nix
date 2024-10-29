{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2024-10-29";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "16ec1bcd37affaca47ce9ba8f288bc0ffb6975ff";
    hash = "sha256-dYCMBle4/UZYpB2UHEPjZObN/CayHBA9f+lWN1bdZLM=";
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
