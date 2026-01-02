{ lib, writeShellScriptBin }:

writeShellScriptBin "clawdis-setup" ''
  set -euo pipefail

  echo "Clawdis setup (Telegram-first, macOS)"
  echo "-------------------------------------"

  default_token_file="/run/agenix/telegram-bot-token"
  read -r -p "Telegram bot token file [${default_token_file}]: " token_file
  token_file="${token_file:-$default_token_file}"

  read -r -p "Allowed chat IDs (space-separated, required): " allow_from
  if [ -z "$allow_from" ]; then
    echo "error: allowFrom is required" >&2
    exit 1
  fi

  default_workspace="$HOME/.clawdis/workspace"
  read -r -p "Workspace dir [${default_workspace}]: " workspace_dir
  workspace_dir="${workspace_dir:-$default_workspace}"

  echo ""
  echo "Paste this into your Home Manager config:"
  echo ""
  cat <<SNIPPET
{
  programs.clawdis = {
    enable = true;
    workspaceDir = "${workspace_dir}";
    providers.telegram = {
      enable = true;
      botTokenFile = "${token_file}";
      allowFrom = [ ${allow_from} ];
    };
    routing.queue.mode = "interrupt";
  };
}
SNIPPET

  echo ""
  echo "Next commands:"
  echo "  home-manager switch --flake .#<profile>"
  echo "  clawdis status"
  echo "  clawdis health"
''
