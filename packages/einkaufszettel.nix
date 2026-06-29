{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2026-06-29";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "b37e1948c47381aeef7eb063cc535ffa8f07db56";
    hash = "sha256-eyCh4PamH3CW2YS4bYz/ndvNk2tznfaiiPkWePrQmMw=";
  };

  cargoHash = "sha256-N04731fDqcSrAQ2Y0U8YBXRgfvIMwyQXctfZ7MiYjho=";
}
