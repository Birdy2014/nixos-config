{ ... }:

{
  users = {
    users.data = {
      group = "data";
      isSystemUser = true;
    };

    groups = {
      data = {
        gid = 1001;
      };
      family = {
        gid = 1002;
      };
    };
  };
}
