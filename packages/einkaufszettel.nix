{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-04-21";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "e425cf65d2c2bd224e9745f3b091d5aecd951837";
    hash = "sha256-NPpk4t67HiPghTpT43dz4QxcwMd219qcrAeQXyNL26E=";
  };

  cargoHash = "sha256-DRhHcc2VJ7sQnFVBfovgP/eSCI6snyzdAI/2Vh2L/+A=";
}
