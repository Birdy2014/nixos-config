{ ... }:

{
  imports = [
    ./authelia.nix
    ./blocky.nix
    ./borg-repos.nix
    ./dashboard
    ./einkaufszettel.nix
    ./immich.nix
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
