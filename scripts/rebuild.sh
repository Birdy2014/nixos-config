#!/usr/bin/env bash

set -euo pipefail

if [[ "$(hostname)" != 'rotkehlchen' ]]; then
    echo "This script should only be executed on rotkehlchen" >&2
    exit 1
fi

if [[ "$#" -lt 2 ]]; then
    echo "Usage: $0 <test|boot|switch> <hostnames...>" >&2
    exit 1
fi

mode="$1"

case "$mode" in
    test|boot|switch)
        ;;
    *)
        echo "Invalid mode '$mode'" >&2
        exit 1
        ;;
esac

shift

flake_path='/etc/nixos'

declare -a commands

for host in "$@"; do
    case "$host" in
        rotkehlchen)
            commands+=("nixos-rebuild $mode --flake $flake_path#rotkehlchen --use-remote-sudo")
            ;;
        seidenschwanz)
            commands+=("ssh seidenschwanz git -C /etc/nixos-secrets pull")
            commands+=("nixos-rebuild $mode --flake $flake_path#seidenschwanz --target-host seidenschwanz")
            ;;
        buntspecht)
            commands+=("ssh buntspecht git -C /etc/nixos-secrets pull")
            commands+=("nixos-rebuild $mode --flake $flake_path#buntspecht --target-host buntspecht --build-host buntspecht --use-substitutes")
            ;;
        zilpzalp)
            commands+=("nixos-rebuild $mode --flake $flake_path#zilpzalp --target-host root@zilpzalp.local")
            ;;
        *)
            echo "Invalid hostname '$host'" >&2
            exit 1
            ;;
    esac
done

for command in "${commands[@]}"; do
    echo "Executing '$command'..."
    $command
    echo
done
