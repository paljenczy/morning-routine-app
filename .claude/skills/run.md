---
name: run
description: Launch the Morning Routine App in Chrome for live UI testing with Chrome DevTools MCP. Kills stale processes, starts the dev server, connects DevTools, takes a screenshot to confirm rendering.
trigger: When the user asks to "run the app", "launch in chrome", "test the UI", "start the app", "open in browser", or any variation of running/testing the app interactively.
allowed-tools: Bash(pkill *), Bash(flutter *), Bash(bash *), Bash(chmod *)
---

# Morning Routine App — Chrome Dev Launch

**Project root:** `/Users/I525520/my-repos/morning_routine_app/`

## Step 1: Kill Stale Processes

```bash
pkill -f "flutter_tools.snapshot" 2>/dev/null
pkill -f "flutter run" 2>/dev/null
pkill -f "dart.*build_runner" 2>/dev/null
lsof -ti tcp:9222 | xargs kill -9 2>/dev/null || true
find /Users/I525520/my-repos/morning_routine_app -name "*.lock" -path "*/.dart_tool/*" -delete 2>/dev/null
true
```

Wait 2 seconds, then continue.

## Step 2: Launch in Chrome (background)

Run `run.sh` as a **background task** (`run_in_background: true`):

```bash
bash /Users/I525520/my-repos/morning_routine_app/run.sh 2>&1
```

Tail the output every 5 seconds until you see:
- `"A Dart VM Service"` or `"is being served at"` → app is ready
- `"Error"` / `"Exception"` → compilation failed

Typical startup: **20–40 seconds** cold, **3–5 seconds** hot reload.

## Step 3: Connect Chrome DevTools MCP

Flutter opens Chrome with its own random debug port. Find it:

```bash
ps aux | grep "Chrome Helper (Renderer)" | grep "remote-debugging-port" | grep -v grep | grep -oE "remote-debugging-port=[0-9]+" | head -1
```

Then get the app page URL from that port:

```bash
curl -s http://localhost:PORT/json | python3 -c "import sys,json; [print(p.get('url','')) for p in json.load(sys.stdin) if 'localhost' in p.get('url','')]"
```

Then open it in DevTools MCP:
1. `new_page` with the app URL
2. `select_page` on it if not already selected

## Step 4: Verify App Rendered

1. Call `take_screenshot` to visually confirm the app loaded.
2. Look for the daily checklist grid (child columns + activity rows).
3. If blank: wait 5s, trigger reload via the flutter process, retry.

## Step 5: Interactive Testing

- **Navigate:** Use `click` with UIDs from `take_snapshot`.
- **Verify state:** `take_snapshot` after each interaction.
- **Screenshots:** `take_screenshot` for visual confirmation.
- **Console errors:** `list_console_messages` after interactions.
- **Hot-reload:** After code edits, the dev server auto-reloads. Re-snapshot to verify.

## Troubleshooting

- **No devices**: Run `flutter devices` to check Chrome is detected.
- **Port conflict**: `lsof -ti:8080 | xargs kill` then retry.
- **Blank screen**: Send `R` (hot-restart) to the flutter process.
