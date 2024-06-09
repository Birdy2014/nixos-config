{ ... }:

{
  imports = [
    ./authelia.nix
    ./blocky.nix
    ./jellyfin.nix
    ./kodi.nix
    ./lldap.nix
    ./paperless.nix
    ./recipes.nix
    ./smb.nix
    ./syncthing.nix
    ./wireguard.nix
  ];
}
