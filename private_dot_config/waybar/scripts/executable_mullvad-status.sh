#!/usr/bin/env bash
set -euo pipefail

if ! command -v mullvad >/dev/null 2>&1; then
  printf '{"text":"󰒄 OFF","class":"vpn-down","tooltip":"Mullvad not installed"}\n'
  exit 0
fi

status="$(mullvad status 2>/dev/null || true)"
tooltip="$(printf '%s' "$status" \
  | sed 's/\r$//' \
  | sed 's/^[[:space:]]\+//; s/[[:space:]]\+$//' \
  | sed '/^$/d' \
  | sed 's/[[:space:]]\{2,\}/ /g' \
  | sed 's/\\/\\\\/g; s/"/\\"/g' \
  | sed ':a;N;$!ba;s/\n/\\n/g')"

# Normalize to one line for matching
s_lc="$(echo "$status" | tr '\n' ' ' | tr '[:upper:]' '[:lower:]')"

# Prefer explicit states
if echo "$s_lc" | grep -qE '\bdisconnected\b|\bnot connected\b|\boffline\b'; then
  printf '{"text":"󰒄 OFF","class":"vpn-down","tooltip":"%s"}\n' "$tooltip"
elif echo "$s_lc" | grep -qE '\bconnecting\b|\breconnecting\b'; then
  printf '{"text":"…","class":"vpn-warn","tooltip":"%s"}\n' "$tooltip"
elif echo "$s_lc" | grep -qE '\bconnected\b'; then
  printf '{"text":"󰒄 MV","class":"vpn-up","tooltip":"%s"}\n' "$tooltip"
else
  # Unknown/edge case
  printf '{"text":"󰒄 OFF","class":"vpn-down","tooltip":"%s"}\n' "$tooltip"
fi
