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

set +e
curl -f https://github.com >/dev/null 2>&1
resolvectl_code="$?"
set -e
has_network() {
    return $resolvectl_code
}

pull_secrets() {
    local host="$1"
    if has_network; then
        echo "Pulling secrets"
        ssh "$host" git -C /etc/nixos-secrets pull
    else
        echo "Offline - skipping secrets"
    fi
}

run_rebuild() {
    local mode="$1"
    shift
    local host="$1"
    shift

    local args=(
        "$mode"
        "--flake"
        "$flake_path#$host"
    )

    has_network || args+=("--offline")

    command="nixos-rebuild ${args[*]} $*"
    echo "Running '$command'"
    $command
}

for host in "$@"; do
    case "$host" in
        rotkehlchen)
            run_rebuild "$mode" rotkehlchen --use-remote-sudo
            ;;
        seidenschwanz)
            pull_secrets seidenschwanz
            echo
            run_rebuild "$mode" seidenschwanz --target-host seidenschwanz
            ;;
        buntspecht)
            pull_secrets buntspecht
            echo
            run_rebuild "$mode" buntspecht --target-host buntspecht --build-host buntspecht --use-substitutes
            ;;
        zilpzalp)
            pull_secrets zilpzalp
            echo
            run_rebuild "$mode" zilpzalp --target-host root@zilpzalp.local
            ;;
        *)
            echo "Invalid hostname '$host'" >&2
            exit 1
            ;;
    esac
done
