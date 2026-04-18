# Claude Code Terminal Notifier

## What this is

A macOS notification system for [Claude Code](https://claude.com/claude-code) that alerts you when Claude finishes responding. Instead of watching the terminal, you can switch to another app and get a native macOS notification with a summary of what Claude just did.

## The problem

When Claude Code is working on a task, it can take anywhere from a few seconds to several minutes. During that time, you might switch to a browser, Slack, or another tool. Without a notification, you have to keep checking back to see if Claude is done.

## How it works

Claude Code supports [hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) — shell commands that run in response to lifecycle events. This project uses the **Stop** hook, which fires every time Claude finishes responding.

When triggered, the hook:

1. Reads the session metadata (passed as JSON via stdin), including the path to the conversation transcript
2. Extracts the current project/repo name from the working directory
3. Parses the transcript file to pull the last assistant message as a summary
4. Plays a sound (`Glass.aiff`) so you hear it even if you're looking away
5. Sends a native macOS notification via `terminal-notifier` with the project name as the title and the response summary as the body

## What a notification looks like

- **Title**: The name of the repo/project folder you're working in
- **Body**: A truncated preview (up to 150 characters) of Claude's last response

## Requirements

- macOS
- [Claude Code](https://claude.com/claude-code)
- [terminal-notifier](https://github.com/julienXX/terminal-notifier) (`brew install terminal-notifier`)
- [jq](https://jqlang.github.io/jq/) (`brew install jq`)

## Setup

### 1. Install dependencies

```bash
brew install terminal-notifier jq
```

### 2. Copy the notification script

Copy `notify-on-stop.sh` to your Claude config directory:

```bash
cp notify-on-stop.sh ~/.claude/notify-on-stop.sh
chmod +x ~/.claude/notify-on-stop.sh
```

### 3. Add the Stop hook to your Claude Code settings

Edit `~/.claude/settings.json` and add (or merge into) the `hooks` section:

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

### 4. Enable notifications for terminal-notifier

Open **System Settings > Notifications** and make sure **terminal-notifier** is set to **Banners** or **Alerts** with notifications enabled. If terminal-notifier doesn't appear in the list, run it once manually:

```bash
terminal-notifier -title "Test" -message "Hello"
```

Then check System Settings again.

### 5. Check Focus mode

If you use macOS Focus or Do Not Disturb, notifications will be suppressed while it's active. Make sure to allow terminal-notifier through your Focus settings if needed.
