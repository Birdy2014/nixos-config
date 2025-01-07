#!/usr/bin/env bash

set -eu

JQ="$(nix build --no-link --print-out-paths nixpkgs#jq^bin)"

jq() {
    "$JQ"/bin/jq "$@"
}

timestamps="$(nix eval --json system#nixosConfigurations.rotkehlchen._module.specialArgs.inputs --apply 'inputs: (builtins.attrValues (builtins.mapAttrs (name: value: { inherit name; timestamp = value.lastModified; }) inputs))')"

echo Flake last updated on: "$(git -C /etc/nixos log -1 --pretty='format:%ar' flake.lock)"
echo ---

current_timestamp="10#$(date '+%s')"

for i in $(seq 0 $(( $(echo "$timestamps" | jq length) - 1 )) ); do
    name="$(echo "$timestamps" | jq -r ".[$i].name")"
    timestamp="$(echo "$timestamps" | jq ".[$i].timestamp")"
    timestamp_diff="$((current_timestamp - timestamp))"
    total_hours="$((timestamp_diff / (60 * 60)))"
    days="$((total_hours / 24))"
    hours="$((total_hours - days * 24))"
    echo -n "$name: "
    if [[ "$days" -gt 0 ]]; then
        echo -n "$days days"
        if [[ "$hours" -gt 0 ]]; then
            echo -n ", $hours hours ago"
        else
            echo -n " ago"
        fi
    elif [[ "$hours" -gt 0 ]]; then
        echo -n "$hours hours ago"
    else
        echo -n 'now'
    fi
    echo
done
