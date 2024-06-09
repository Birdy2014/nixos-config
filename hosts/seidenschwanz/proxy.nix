{ config, lib, ... }:

# TODO: Add `my.proxy.domains.<name>.localOnly` or `allowPublic`?

let cfg = config.my.proxy;
in {
  options.my.proxy.domains = lib.mkOption {
    description = "Domains to proxy";
    default = { };
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        proxyPass = lib.mkOption {
          type = lib.types.str;
          description = "The target url of the proxy.";
        };
        enableAuthelia = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable authelia with trusted header sso";
        };
      };
    });
  };

  config = {
    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;

      virtualHosts = lib.listToAttrs (lib.flatten (lib.mapAttrsToList
        (domainName: domainConfig: [
          {
            name = "acme-${domainName}";
            value = {
              serverName = "${domainName}.seidenschwanz.mvogel.dev";
              enableACME = true;
              addSSL = false;
              locations."/".return = "301 https://$host$request_uri";
            };
          }
          {
            name = domainName;
            value = {
              serverName = "${domainName}.seidenschwanz.mvogel.dev";
              onlySSL = true;
              useACMEHost = "${domainName}.seidenschwanz.mvogel.dev";
              listenAddresses = [ "[fd00:90::10]" "192.168.90.10" ];
              locations."/" = {
                proxyPass = "${domainConfig.proxyPass}";
                recommendedProxySettings = true;
                extraConfig = lib.mkIf domainConfig.enableAuthelia ''
                  ## Send a subrequest to Authelia to verify if the user is authenticated and has permission to access the resource.
                  auth_request /authelia;

                  ## Set the $target_url variable based on the original request.

                  set $target_url $scheme://$http_host$request_uri;

                  ## Save the upstream response headers from Authelia to variables.
                  auth_request_set $user $upstream_http_remote_user;
                  auth_request_set $groups $upstream_http_remote_groups;
                  auth_request_set $name $upstream_http_remote_name;
                  auth_request_set $email $upstream_http_remote_email;

                  ## Inject the response headers from the variables into the request made to the backend.
                  proxy_set_header Remote-User $user;
                  proxy_set_header Remote-Groups $groups;
                  proxy_set_header Remote-Name $name;
                  proxy_set_header Remote-Email $email;

                  ## If the subreqest returns 200 pass to the backend, if the subrequest returns 401 redirect to the portal.
                  error_page 401 =302 https://auth.seidenschwanz.mvogel.dev/?rd=$target_url;
                '';
              };
              locations."/authelia" = lib.mkIf domainConfig.enableAuthelia {
                proxyPass = "http://localhost:9091/api/verify";
                extraConfig = ''
                  internal;

                  ## Headers
                  ## The headers starting with X-* are required.
                  proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
                  proxy_set_header X-Original-Method $request_method;
                  proxy_set_header X-Forwarded-Method $request_method;
                  proxy_set_header X-Forwarded-Proto $scheme;
                  proxy_set_header X-Forwarded-Host $http_host;
                  proxy_set_header X-Forwarded-Uri $request_uri;
                  proxy_set_header X-Forwarded-For $remote_addr;
                  proxy_set_header Content-Length "";
                  proxy_set_header Connection "";
                '';
              };
            };
          }
        ]) cfg.domains));
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
