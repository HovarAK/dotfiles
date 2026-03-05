#!/usr/bin/env bash
set -euo pipefail

notify() {
  command -v notify-send >/dev/null 2>&1 \
    && notify-send "Tailscale" "$1" >/dev/null 2>&1 \
    || true
}

run_root() {
  # Prefer pkexec when available; fall back to direct
  if command -v pkexec >/dev/null 2>&1; then
    pkexec "$@" >/dev/null 2>&1 || "$@" >/dev/null 2>&1
  else
    "$@" >/dev/null 2>&1
  fi
}

systray_running() {
  # Match the systray specifically (not transient 'tailscale' CLI calls)
  pgrep -fa '(^|/| )tailscale( |$).* systray( |$)' >/dev/null 2>&1
}

daemon_running() {
  systemctl is-active --quiet tailscaled 2>/dev/null
}

# If systray is already running, nothing to do
if systray_running; then
  exit 0
fi

# Ensure the daemon is running (systray is useless if tailscaled is down)
if ! daemon_running; then
  run_root systemctl start tailscaled || true
fi

# Start the systray UI
setsid -f tailscale systray >/dev/null 2>&1 || true

# Notify user
notify "Systray started — click the tray icon for menu."
