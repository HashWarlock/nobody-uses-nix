import json
import sys
import urllib.request

def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)

if len(sys.argv) != 2:
    die("Usage: python3 get-telegram-chat-ids.py <tokenPath>")

token_path = sys.argv[1]
try:
    with open(token_path, "r", encoding="utf-8") as f:
        token = f.read().strip()
except FileNotFoundError:
    die(f"Token file not found: {token_path}")

if not token:
    die("Token file is empty")

url = f"https://api.telegram.org/bot{token}/getUpdates"
try:
    with urllib.request.urlopen(url) as resp:
        data = json.loads(resp.read().decode("utf-8"))
except Exception as exc:
    die(f"Failed to call Telegram API: {exc}")

results = data.get("result", [])
chat_ids = []
for entry in results:
    msg = entry.get("message") or entry.get("edited_message")
    if not msg:
        continue
    chat = msg.get("chat") or {}
    cid = chat.get("id")
    if cid is not None and cid not in chat_ids:
        chat_ids.append(cid)

print("Chat IDs:")
for cid in chat_ids:
    print(cid)
