{ config, ... }:

{
  security.acme.certs."seidenschwanz.mvogel.dev" = {
    extraDomainNames = [ "*.seidenschwanz.mvogel.dev" ];
    dnsProvider = "rfc2136";
    dnsResolver = "1.1.1.1:53";
    environmentFile = config.sops.templates."bind-acme-certs".path;
  };

  sops.templates."bind-acme-certs".content = ''
    RFC2136_NAMESERVER=ns1.mvogel.dev
    RFC2136_TSIG_ALGORITHM=hmac-sha256.
    RFC2136_TSIG_KEY=seidenschwanz.mvogel.dev
    RFC2136_TSIG_SECRET=${config.sops.placeholder."bind-dnskey_seidenschwanz.mvogel.dev"}
  '';
}
