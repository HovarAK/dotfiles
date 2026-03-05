#!/usr/bin/env bash
set -euo pipefail

FILE="${HOME}/.config/hypr/cheatsheet.txt"

# Show the cheat sheet as a selectable list (read-only).
# Escape tabs/newlines are preserved as lines.
fuzzel --dmenu --prompt "Cheat Sheet" < "$FILE" >/dev/null
