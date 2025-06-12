{ ... }:

{
  services.nginx.commonHttpConfig = ''
    map $remote_addr $remote_addr_anon {
      ~(?P<ip>\d+\.\d+\.\d+)\.    $ip.0;
      ~(?P<ip>[^:]+:[^:]+):       $ip::;
      default                     0.0.0.0;
    }

    log_format   anonip '$remote_addr_anon - $remote_user [$time_local]  $status '
      '"$request" $body_bytes_sent "$http_referer" '
      '"$http_user_agent"';

    access_log   /var/log/nginx/access.log  anonip;
  '';

  services.logrotate.settings.nginx = {
    frequency = "daily";
    rotate = 6;
  };
}
