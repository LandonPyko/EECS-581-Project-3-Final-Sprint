#!/bin/sh
echo -ne '\033c\033]0;Tanks\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Tanks.x86_64" "$@"
