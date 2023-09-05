#!/usr/bin/env bash

# FIXME: Remove this
set +o nounset

IFS=$'\n'

command -v playerctl &> /dev/null || exit 1
[[ -z "$XDG_RUNTIME_DIR" ]] && exit 1

TMP_DIR="${XDG_RUNTIME_DIR}/playerctl-current"
[[ -d "$TMP_DIR" ]] || mkdir -p "$TMP_DIR"
PLAYER_FILE="$TMP_DIR/last_player"
[[ -e "$PLAYER_FILE" ]] || touch "$PLAYER_FILE"

players=$(playerctl --list-all)

# FIXME: fix shellcheck error
# shellcheck disable=SC2068
for player in ${players[@]} ; do
    current_status="$(playerctl --player "$player" status 2>&1)"
    if [[ "$current_status" = "Playing" ]]; then
        selected_player="$player"
        echo -n "$selected_player" > "$PLAYER_FILE"
        break
    fi
done

[[ -z "$selected_player" ]] && selected_player=$(<"$PLAYER_FILE")
[[ -z "$selected_player" ]] && selected_player="${players[0]}"

playerctl --player "$selected_player" "$@"
