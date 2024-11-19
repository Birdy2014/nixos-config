# TODO: Remove once https://github.com/NixOS/nixpkgs/pull/346360 is merged
final: prev: {
  spicetify-cli = (prev.spicetify-cli.override (old: {
    buildGoModule = args:
      prev.buildGoModule (args // rec {
        version = "2.38.4";
        src = prev.fetchFromGitHub {
          owner = "spicetify";
          repo = "cli";
          rev = "v${version}";
          hash = "sha256-KmIGoDCqJvuaxWp3dHQQ81m7+dzCmZ+rDrNpmehP9cM=";
        };
        vendorHash = "sha256-BT/zmeNKr2pNBSCaRtT/Dxm3uCshd1j4IW0xU7b9Yz4=";
      });
  }));
}
