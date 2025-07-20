{ ... }:

{
  services.borgbackup.repos = {
    rotkehlchen-moritz-home = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjBJPUl3mq2daBLYr/BlGFTqC2M26iSeRtBC+voY+WQ moritz@rotkehlchen"
      ];
      path = "/zpool/backup/rotkehlchen-moritz-home";
    };

    buntspecht-data = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN92KId7ci+zdSPs7XhaxWQInEIB80P+gaXD0B+3yn32 root@buntspecht"
      ];
      path = "/zpool/backup/buntspecht-data";
    };

    zilpzalp-moritz-home = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyGjxCdTnpzhofvJMq29tHQnjTqOk0lC15L1OJPgfX8 moritz@zilpzalp"
      ];
      path = "/zpool/backup/zilpzalp-moritz-home";
    };
  };
}
