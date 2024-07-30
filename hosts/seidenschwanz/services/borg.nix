{ ... }:

{
  services.borgbackup.repos.rotkehlchen-moritz-home = {
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjBJPUl3mq2daBLYr/BlGFTqC2M26iSeRtBC+voY+WQ moritz@rotkehlchen"
    ];
    path = "/zpool/backup/rotkehlchen-moritz-home";
  };
}
