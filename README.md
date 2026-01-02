# nix-clawdis

Declarative Clawdis for macOS via Nix, designed to be **agent‑first**.

## Scope boundaries

- This repo is a **public, generic** Nix package + Home Manager module for Clawdis.
- It does **not** include or depend on any personal `nixos-config` or private machine setup.

## Agent‑first onboarding (the only supported path)

This README is the **single source of truth**. Do not look for other docs.

### Human‑in‑the‑loop (you must do these)

1) Create a Telegram bot token and save it to a file on disk.
   - Recommended path: `/run/agenix/telegram-bot-token`
   - If you do not use agenix, any readable file path works.
2) Send a Telegram message to your bot from the chat(s) you want to allow.
   - This is required so chat IDs appear in Telegram’s updates feed.
3) Provide these inputs to the agent (no guesswork):
   - macOS version
   - CPU architecture: `arm64` or `x86_64`
   - Home Manager configuration name (e.g. `myuser`)
   - Telegram bot token file path
   - Telegram allowFrom chat IDs (list of ints)

Do not proceed unless all inputs above are provided.

### Agent‑only steps (no human intervention)

1) Check if Determinate Nix is installed. If not, install it.
   - If `nix --version` fails, run:
     `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`
2) Enable flakes in `~/.config/nix/nix.conf`.
   - Ensure the directory exists: `mkdir -p ~/.config/nix`
   - Ensure this line exists: `experimental-features = nix-command flakes`
3) Create a fresh local flake at `~/code/clawdis-local`.
4) Copy the template file from this repo:
   - Source: `templates/agent-first/flake.nix`
   - Target: `~/code/clawdis-local/flake.nix`
   - Command: `cp templates/agent-first/flake.nix ~/code/clawdis-local/flake.nix`
5) Replace placeholders in `~/code/clawdis-local/flake.nix`:
   - `<system>` = `aarch64-darwin` for arm64, `x86_64-darwin` for Intel
   - `<user>` = Home Manager configuration name
   - `<tokenPath>` = Telegram bot token file path
   - `<allowFrom>` = space‑separated list of ints
   - Do not leave any placeholders in the file.
   - After editing, re-open the file and verify there are no `<...>` strings left.
6) Validate the token file exists and is non‑empty before proceeding.
   - If the file does not exist or is empty, stop and ask the human to fix it.
7) If the human did not supply chat IDs, run the helper:
   - File: `templates/agent-first/get-telegram-chat-ids.py`
   - Command: `python3 templates/agent-first/get-telegram-chat-ids.py <tokenPath>`
   - Ask the human to pick which chat IDs to allow.
   - If the helper returns no chat IDs, stop and ask the human to send a message, then re‑run the helper.
   - If `python3` is missing, ask the human to install Xcode Command Line Tools.
8) Run Home Manager:
   - If not installed: `nix run home-manager/release-24.11 -- init`
     - If this command fails, stop and ask the human for approval to proceed.
   - Then: `home-manager switch --flake .#<user>`
9) Verify:
   - `launchctl print gui/$UID/com.nix-clawdis.gateway | grep state`
   - `tail -n 50 ~/.clawdis/logs/clawdis-gateway.log`
10) Ask the human to send a test message and confirm a reply.

### Expected success signals

- `launchctl print` shows `state = running`.
- Log file contains no fatal errors on startup.
- Bot replies to a message in an allowlisted chat.

### Deterministic checklist (agent self‑test)

The agent’s work is correct **only if** all checks pass:

- A new local flake exists at `~/code/clawdis-local`.
- That flake references `github:joshp123/nix-clawdis` as an input.
- Home Manager config enables `programs.clawdis` with Telegram enabled.
- Token is referenced by a file path (no inline secrets).
- `launchctl print gui/$UID/com.nix-clawdis.gateway | grep state` shows `state = running`.
- `~/.clawdis/logs/clawdis-gateway.log` shows startup without fatal errors.
- A real Telegram message in an allowlisted chat receives a bot response.

If any item fails, the setup is incomplete.

## Status

The RFC lives at `docs/rfc/2026-01-02-declarative-clawdis-nix.md` and defines success criteria.
