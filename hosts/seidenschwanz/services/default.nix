{ ... }:

{
  imports = [
    ./authelia.nix
    ./blocky.nix
    ./jellyfin.nix
    ./kodi.nix
    ./lldap.nix
    ./mealie.nix
    ./paperless.nix
    ./smb.nix
    ./syncthing.nix
    ./wireguard.nix
  ];
}
