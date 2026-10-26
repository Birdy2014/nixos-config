{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-10-26";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "27309febf8f050ae15043634fb0801afc1b0342d";
    hash = "sha256-/oX4vhyn/Tjf0Y9332LoHKuTqDP381MDrSnivjtd+9Q=";
  };

  npmDepsHash = "sha256-SxCbBNAEypX+66dvFMByhXEUk4kH78gHmaglDU11Bkw=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
