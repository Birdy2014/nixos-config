{ ... }:

{
  services.borgbackup.repos = {
    seidenschwanz = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEViwTAQx1qrlppmdnHJEeMb6rBFO+sH1jbcT47lnJrR moritz@seidenschwanz"
      ];
      path = "/mnt/backup/seidenschwanz";
    };
  };
}
