{ config, pkgs, ... }:

{
  security.acme.certs."seidenschwanz.mvogel.dev" = {
    extraDomainNames = [ "*.seidenschwanz.mvogel.dev" ];
    dnsProvider = "rfc2136";
    dnsResolver = "1.1.1.1:53";
    environmentFile = pkgs.writeText "lego-seidenschwanz.mvogel.dev" ''
      RFC2136_NAMESERVER=ns1.mvogel.dev
      RFC2136_TSIG_ALGORITHM=hmac-sha256.
      RFC2136_TSIG_KEY=seidenschwanz.mvogel.dev
    '';
    credentialFiles."RFC2136_TSIG_SECRET_FILE" =
      config.sops.secrets."bind-dnskey_seidenschwanz.mvogel.dev".path;
  };
}
