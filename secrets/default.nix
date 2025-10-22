{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./common.nix
  ];

  # Needed when the sops files are not in the nix store.
  sops.validateSopsFiles = false;
}
