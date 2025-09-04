{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-09-04";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "1f2ca6ad9e2a8942e38c57789b52135370499fde";
    hash = "sha256-yX393Ji2uBLQ2rHQLzkS4TGMUipEcLXTF4yB7Obd7m0=";
  };

  cargoHash = "sha256-r6jG4NChrIDTpNenLE/Zij8ryXgaKpd10mEIL7ueMAo=";
}
