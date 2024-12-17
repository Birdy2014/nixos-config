{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2024-12-16";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "6ecd15c103f036a072f630c8952e137dcec568d3";
    hash = "sha256-vWXj3aA9LA3Wkv2Ql7NyRxmE+PJeYTgCG/rIk60G/ug=";
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
