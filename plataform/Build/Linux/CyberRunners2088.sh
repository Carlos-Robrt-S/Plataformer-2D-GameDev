#!/bin/sh
printf '\033c\033]0;%s\a' Plataform
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CyberRunners2088.x86_64" "$@"
