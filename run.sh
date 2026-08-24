#!/usr/bin/env bash
# run.sh — launch Morning Routine App in Chrome for development
#
# Usage:
#   ./run.sh              # Chrome (default)
#   ./run.sh --macos      # macOS desktop (requires Xcode)
#   ./run.sh --device ID  # Specific device ID
#   ./run.sh --no-watch   # Skip build_runner watch
#   ./run.sh --release    # Release mode

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults
DEVICE="${FLUTTER_DEVICE:-chrome}"
START_WATCH=false
EXTRA_ARGS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --macos)
      DEVICE="macos"
      shift
      ;;
    --device)
      DEVICE="$2"
      shift 2
      ;;
    --no-watch)
      START_WATCH=false
      shift
      ;;
    --watch)
      START_WATCH=true
      shift
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

# Start build_runner watch in background (only if requested)
WATCH_PID=""
if $START_WATCH; then
  echo "Starting build_runner watch in background..."
  cd "$SCRIPT_DIR"
  dart run build_runner watch --delete-conflicting-outputs 2>&1 | sed 's/^/[codegen] /' &
  WATCH_PID=$!

  cleanup() {
    if [[ -n "$WATCH_PID" ]] && kill -0 "$WATCH_PID" 2>/dev/null; then
      kill "$WATCH_PID" 2>/dev/null || true
    fi
  }
  trap cleanup EXIT
fi

echo ""
echo "=== Morning Routine App Dev ==="
echo "Device:  $DEVICE"
if [[ -n "$WATCH_PID" ]]; then
  echo "Codegen: build_runner watch (PID $WATCH_PID)"
fi
echo ""
echo "Hot-reload keys (once running):"
echo "  r  — Hot reload  (sub-second, keeps state)"
echo "  R  — Hot restart (full restart, ~2-3s)"
echo "  q  — Quit"
echo ""

cd "$SCRIPT_DIR"
if [[ "$DEVICE" == "chrome" ]]; then
  # Kill any Chrome instance already holding port 9222
  lsof -ti tcp:9222 | xargs kill -9 2>/dev/null || true
  sleep 1
  # Use a wrapper that injects --remote-debugging-port=9222 so DevTools MCP can attach
  export CHROME_EXECUTABLE="$SCRIPT_DIR/tools/chrome-debug.sh"
fi
flutter run -d "$DEVICE" "${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}"
