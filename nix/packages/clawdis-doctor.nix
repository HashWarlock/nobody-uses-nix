{ lib, writeShellScriptBin }:

writeShellScriptBin "clawdis-doctor" ''
  set -euo pipefail

  config="$HOME/.clawdis/clawdis.json"
  log="$HOME/.clawdis/logs/clawdis-gateway.log"

  if [ ! -f "$config" ]; then
    echo "clawdis-doctor: missing config at $config" >&2
    exit 1
  fi

  if launchctl print gui/$UID/com.joshp123.clawdis.gateway >/dev/null 2>&1; then
    echo "launchd: running"
  else
    echo "launchd: not running (try: launchctl kickstart -k gui/$UID/com.joshp123.clawdis.gateway)"
  fi

  if [ -f "$log" ]; then
    echo "log: $log"
  else
    echo "log: missing ($log)"
  fi

  if command -v clawdis >/dev/null 2>&1; then
    echo "cli: clawdis found"
  else
    echo "cli: clawdis not on PATH"
  fi
''
