{ ... }:

{
  services.smartd = {
    enable = true;
    notifications.mail = {
      sender = "moritzv7@gmail.com";
      recipient = "moritzv7+monitoring@gmail.com";
    };
  };
}
