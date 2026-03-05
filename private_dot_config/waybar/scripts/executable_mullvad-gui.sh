#!/usr/bin/env bash
set -euo pipefail

GUI="/opt/Mullvad VPN/mullvad-vpn"

# Start GUI if not running
if ! pgrep -x mullvad-vpn >/dev/null 2>&1; then
  setsid -f "$GUI" >/dev/null 2>&1 || ("$GUI" >/dev/null 2>&1 &)
  exit 0
fi

# If running, focus it (Hyprland)
hyprctl dispatch focuswindow class:mullvad-vpn >/dev/null 2>&1 && exit 0
hyprctl dispatch focuswindow class:"Mullvad VPN" >/dev/null 2>&1 && exit 0
hyprctl dispatch focuswindow title:"Mullvad" >/dev/null 2>&1 && exit 0

# Fallback: try launching again (usually brings it forward or is harmless)
setsid -f "$GUI" >/dev/null 2>&1 || ("$GUI" >/dev/null 2>&1 &)
