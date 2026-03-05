#!/usr/bin/env bash
set -euo pipefail

# Bring up Tailscale with your desired prefs
UP_CMD=(tailscale up --accept-dns=true --ssh)

run_root() {
  # Prefer pkexec when available; fall back to direct
  if command -v pkexec >/dev/null 2>&1; then
    pkexec "$@" >/dev/null 2>&1 || "$@" >/dev/null 2>&1
  else
    "$@" >/dev/null 2>&1
  fi
}

get_state_from_json() {
  python3 -c 'import json,sys
try:
  d=json.load(sys.stdin)
  print(d.get("BackendState",""))
except Exception:
  print("")'
}

prompt_kitty() {
  local msg="$1"
  if command -v kitty >/dev/null 2>&1; then
    kitty -e sh -lc "printf '%s\n\n' \"$msg\"; read -r -p 'Press Enter to close...'" >/dev/null 2>&1 || true
  fi
}

# Ensure daemon is running
if ! systemctl is-active --quiet tailscaled 2>/dev/null; then
  run_root systemctl start tailscaled || true
fi

status_json="$(tailscale status --json 2>/dev/null || true)"
state="$(printf '%s' "$status_json" | get_state_from_json || true)"

case "$state" in
  Running)
    run_root tailscale down || true
    ;;
  NeedsLogin)
    prompt_kitty $'Tailscale needs login.\n\nRun:\n  sudo tailscale up --accept-dns=true --ssh'
    ;;
  Stopped|"")
    if ! run_root "${UP_CMD[@]}"; then
      prompt_kitty $'tailscale up failed.\n\nTry:\n  sudo tailscale up --accept-dns=true --ssh\n\nIf you changed flags recently, recovery:\n  sudo tailscale up --reset --accept-dns=true --ssh'
    fi
    ;;
  Starting|*)
    run_root "${UP_CMD[@]}" || true
    ;;
esac
