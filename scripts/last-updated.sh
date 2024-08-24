#!/usr/bin/env bash

set -eu

JQ="$(nix build --no-link --print-out-paths nixpkgs#jq^bin)"

jq() {
    "$JQ"/bin/jq "$@"
}

timestamps="$(nix eval --json system#nixosConfigurations.rotkehlchen._module.specialArgs.inputs --apply 'inputs: (builtins.attrValues (builtins.mapAttrs (name: value: { inherit name; timestamp = value.lastModified; }) inputs))')"

echo Flake last updated on: "$(git -C /etc/nixos log -1 --pretty='format:%ar' flake.lock)"
echo ---

current_day="$(date '+%j')"
current_hour="$(date '+%H')"

for i in $(seq 0 $(( $(echo "$timestamps" | jq length) - 1 )) ); do
    name="$(echo "$timestamps" | jq -r ".[$i].name")"
    timestamp="$(echo "$timestamps" | jq ".[$i].timestamp")"
    day="$(date -d @"${timestamp}" '+%j')"
    hour="$(date -d @"${timestamp}" '+%H')"
    day_difference="$(( current_day - day ))"
    hour_difference="$(( current_hour - hour ))"
    echo -n "$name: "
    if [[ "$day_difference" -gt 0 ]]; then
        echo -n "$day_difference days"
        if [[ "$hour_difference" -gt 0 ]]; then
            echo -n ", $hour_difference hours ago"
        else
            echo -n " ago"
        fi
    elif [[ "$hour_difference" -gt 0 ]]; then
        echo -n "$hour_difference hours ago"
    else
        echo -n 'now'
    fi
    echo
done
