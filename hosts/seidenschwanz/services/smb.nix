{ ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";

    extraConfig = ''
      workgroup = WORKGROUP
      server string = seidenschwanz

      # Fix special characters under linux
      vfs objects = catia fruit
      fruit:encoding = native
    '';
    shares = let
      sharedOptions = {
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "data";
        "force group" = "data";
      };
    in {
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
