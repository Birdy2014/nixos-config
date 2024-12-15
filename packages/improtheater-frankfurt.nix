{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2024-12-15";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "db27f8df7ab557c64c8edeb363efdb998c7013b7";
    hash = "sha256-zpEYgIP124D/oQ3I2MCL7iDv82x8qQaXdRsnapmp2RM=";
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
