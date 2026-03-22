{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2026-03-22";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "9b31c73b81c6a035d8ecf6b2405c79ff654ac1ac";
    hash = "sha256-ksr3jnZgyahahQSArhgasjlv91cqktDlLSAVsDYkuu4=";
  };

  cargoHash = "sha256-N04731fDqcSrAQ2Y0U8YBXRgfvIMwyQXctfZ7MiYjho=";
}
