#!/usr/bin/env bash
set -euo pipefail

ICON="󰖂"

# Basic checks
if ! command -v tailscale >/dev/null 2>&1; then
  python3 -c 'import json; print(json.dumps({"text":"'"${ICON}"' OFF","class":"ts-down","tooltip":"Tailscale not installed"}))'
  exit 0
fi

if ! systemctl is-active --quiet tailscaled 2>/dev/null; then
  python3 -c 'import json; print(json.dumps({"text":"'"${ICON}"' OFF","class":"ts-down","tooltip":"tailscaled: inactive"}))'
  exit 0
fi

status_json="$(tailscale status --json 2>/dev/null || true)"
if [[ -z "${status_json//[[:space:]]/}" ]]; then
  python3 -c 'import json; print(json.dumps({"text":"'"${ICON}"' …","class":"ts-warn","tooltip":"tailscale status unavailable"}))'
  exit 0
fi

# Let Python produce the final Waybar JSON (no bash parsing/escaping)
python3 -c 'import json,sys
ICON="'"${ICON}"'"
d=json.loads(sys.stdin.read())
backend=d.get("BackendState","unknown")
self=d.get("Self",{}) or {}

host=self.get("HostName") or "unknown"
magic=self.get("DNSName") or self.get("TailscaleName") or host or "unknown"

# IPs: prefer Self.TailscaleIPs, else top-level
addrs=[]
v=self.get("TailscaleIPs")
if isinstance(v,list): addrs+=v
v=d.get("TailscaleIPs")
if isinstance(v,list): addrs+=v

ip4=next((a for a in addrs if isinstance(a,str) and ":" not in a), "-")
ip6=next((a for a in addrs if isinstance(a,str) and ":" in a), "-")
ip_short = ip4 if ip4 != "-" else ip6

# Peers online (best-effort; varies by version)
peers_online=0
peers_obj=d.get("Peer") or d.get("Peers") or d.get("PeerMap") or {}
if isinstance(peers_obj, dict):
    for p in peers_obj.values():
        if isinstance(p, dict) and p.get("Online") is True:
            peers_online += 1
elif isinstance(peers_obj, list):
    for p in peers_obj:
        if isinstance(p, dict) and p.get("Online") is True:
            peers_online += 1

magic_short = magic.split(".",1)[0] if isinstance(magic,str) else "unknown"

tooltip = (
    f"State: {backend}\n"
    f"Host: {host}\n"
    f"MagicDNS: {magic}\n"
    f"IPv4: {ip4}\n"
    f"IPv6: {ip6}\n"
    f"Peers online: {peers_online}"
)

if backend=="Running":
    out={"text":f"{ICON} TS {ip_short} {magic_short} ({peers_online})","class":"ts-up","tooltip":tooltip}
elif backend=="Stopped":
    out={"text":f"{ICON} OFF","class":"ts-down","tooltip":tooltip}
else:
    label = "LOGIN" if backend=="NeedsLogin" else "…"
    out={"text":f"{ICON} {label}","class":"ts-warn","tooltip":tooltip}

print(json.dumps(out))' <<<"$status_json"
