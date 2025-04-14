{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-04-14";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "8d9392bcc09ec075a6f91364eb01f7a472cbfa99";
    hash = "sha256-WTz78YWOT39UyJN+LUravVZddv/uB4SXdCyqaz8GyF0=";
  };

  cargoHash = "sha256-8QPwt2FTXV6H692RFQjrJp3BHi8JxIEpFDDv3wR60ZY=";
}
