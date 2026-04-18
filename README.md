# Claude Code Terminal Notifier

Get a native macOS notification with a summary of what Claude did every time [Claude Code](https://claude.com/claude-code) finishes responding. Never stare at the terminal waiting again.

## How it works

Uses Claude Code's [Stop hook](https://docs.anthropic.com/en/docs/claude-code/hooks) to parse the conversation transcript and send a notification via `terminal-notifier`. The notification title is your current project name, and the body is a preview of Claude's last response.

## Setup

### 1. Install dependencies

```bash
brew install terminal-notifier jq
```

### 2. Install the hook script

```bash
curl -o ~/.claude/notify-on-stop.sh https://raw.githubusercontent.com/ccosnett/claude-code-terminal-notifier/main/notify-on-stop.sh
chmod +x ~/.claude/notify-on-stop.sh
```

### 3. Add the hook to `~/.claude/settings.json`

Merge this into your existing settings:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/notify-on-stop.sh"
          }
        ]
      }
    ]
  }
}
```

### 4. Allow notifications

Open **System Settings > Notifications** and enable notifications for **terminal-notifier**. If it doesn't appear, run `terminal-notifier -title "Test" -message "Hello"` once first.

> **Note:** macOS Focus / Do Not Disturb will suppress notifications. Allow `terminal-notifier` through your Focus settings if needed.
