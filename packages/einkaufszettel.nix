{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2026-06-30";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "81c810b24ea50c370a66673c4a7ba41368d4dd29";
    hash = "sha256-8wMC/jiR9/hSlmbTOzfTc3ap0guvDD1t6rLkxi4OiX0=";
  };

  cargoHash = "sha256-N04731fDqcSrAQ2Y0U8YBXRgfvIMwyQXctfZ7MiYjho=";
}
