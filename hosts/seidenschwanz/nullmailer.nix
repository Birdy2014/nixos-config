{ config, ... }:

{
  services.nullmailer = {
    enable = true;
    setSendmail = true;
    remotesFile = config.sops.templates."nullmailer-remotes".path;
    config = {
      allmailfrom = "moritzv7@gmail.com";
      adminaddr = "moritzv7+monitoring@gmail.com";
    };
  };

  sops.templates."nullmailer-remotes" = {
    owner = config.services.nullmailer.user;
    group = config.services.nullmailer.group;
    content = ''
      smtp.gmail.com smtp --auth-login --port=587 --starttls --user=moritzv7@gmail.com --pass='${config.sops.placeholder.nullmailer-gmail-password}'
    '';
  };
}
