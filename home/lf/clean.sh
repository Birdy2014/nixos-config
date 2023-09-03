#!/usr/bin/env bash

if [[ "$TERM" =~ .*kitty.* ]]; then
    kitten icat --clear --silent --stdin no --transfer-mode memory < /dev/null > /dev/tty
fi
