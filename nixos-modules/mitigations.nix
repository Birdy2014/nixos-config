{ lib, ... }:

{
  # Mitigate CVE-2026-123007 and CVE-2026-123633
  # TODO: Remove after update to nginx 1.30.7 or 1.31.9
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config.http2 = lib.mkDefault false;
      }
    );
  };
}
