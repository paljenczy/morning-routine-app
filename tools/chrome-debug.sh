#!/usr/bin/env bash
# Chrome wrapper that injects --remote-debugging-port=9222 for DevTools MCP.
# Used by run.sh via CHROME_EXECUTABLE.
exec "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --remote-debugging-port=9222 \
  "$@"
