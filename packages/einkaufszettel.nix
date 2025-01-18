{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-01-18";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "901c730675700b17b917a26eb15dca2b12e70dcf";
    hash = "sha256-LFAwkHZGYFd25tSdnrhzNlN9ulmVsPQ92ezPl1Vh3kk=";
  };

  cargoHash = "sha256-8QPwt2FTXV6H692RFQjrJp3BHi8JxIEpFDDv3wR60ZY=";
}
