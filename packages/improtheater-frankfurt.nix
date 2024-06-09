{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-05-27";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "799161b964284fd67e419617c84f6667dd97ebf4";
    hash = "sha256-NABp4SVcLQQ+IZNmy6yhoubBm1TnHmC8ZPWNAcvsWs0=";
  };

  npmDepsHash = "sha256-HHdnX/TnGa99vqUM9fr4YrVVVS04QSUzretM22Dh6/o=";

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
