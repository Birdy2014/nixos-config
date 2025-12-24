#!/usr/bin/env python3

import requests
import sys


def fetch_blocklist(country: str, ipv6: bool) -> list[str]:
    if ipv6:
        address = f"https://www.ipdeny.com/ipv6/ipaddresses/aggregated/{country}-aggregated.zone"
    else:
        address = (
            f"https://www.ipdeny.com/ipblocks/data/aggregated/{country}-aggregated.zone"
        )
    r = requests.get(address)

    if r.status_code != 200:
        raise Exception("Failed to fetch blocklist")

    return r.text.strip().split("\n")


def build_table(countries: list[str]) -> str:
    ipv4 = [
        address for country in countries for address in fetch_blocklist(country, False)
    ]
    ipv6 = [
        address for country in countries for address in fetch_blocklist(country, True)
    ]

    table = """table inet geoblock {{
    set geoip-ipv4 {{
        type ipv4_addr
        flags interval
        auto-merge
        elements = {{ {ipv4} }}
    }}

    set geoip-ipv6 {{
        type ipv6_addr
        flags interval
        auto-merge
        elements = {{ {ipv6} }}
    }}

    chain input {{
        type filter hook input priority filter; policy accept;
        ip saddr @geoip-ipv4 drop
        ip6 saddr @geoip-ipv6 drop
    }}
}}""".format(
        ipv4=", ".join(ipv4), ipv6=", ".join(ipv6)
    )

    return table


def main():
    if len(sys.argv) < 2:
        exit(1)
    print(build_table(sys.argv[1:]))


if __name__ == "__main__":
    main()
