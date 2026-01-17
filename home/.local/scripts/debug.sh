#!/bin/bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-debug-binary> [service-args...]" >&2
  exit 1
fi

BINARY="$1"
shift

if ! command -v dlv &> /dev/null; then
  echo "Error: delve (dlv) not found. Install: go install github.com/go-delve/delve/cmd/dlv@latest" >&2
  exit 1
fi

if [[ ! -f "$BINARY" ]]; then
  echo "Error: Binary '$1' not found" >&2
  exit 1
fi


PORT="${DLV_PORT:-2345}"

OPTS=(
  --headless
  --accept-multiclient
  --continue
  --listen=":$PORT"
  --api-version=2
)

echo "Starting delve on port ${PORT}..." >&2

dlv exec "${OPTS[@]}" "$BINARY" -- "$@"
