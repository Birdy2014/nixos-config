{ ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = let
      sharedOptions = {
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "data";
        "force group" = "data";
      };
    in {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "seidenschwanz";
        security = "user";

        # Fix special characters under linux
        "vfs objects" = "catia fruit";
        "fruit:encoding" = "native";
      };
      family = sharedOptions // {
        path = "/zpool/shares/family";
        "valid users" = "@family";
      };
      homes = sharedOptions // {
        path = "/zpool/shares/%S";
        "valid users" = "%S";
        browseable = "no";
      };
    };
  };
}
