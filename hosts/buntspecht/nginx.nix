{ ... }:

{
  services.nginx.commonHttpConfig = ''
    access_log off;
  '';
}
