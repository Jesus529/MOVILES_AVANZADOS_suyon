#!/usr/bin/env bash
set -euo pipefail
DEVICE_ID=$(xcrun simctl list devices available -j | python3 -c 'import sys,json; d=json.load(sys.stdin); a=[x for v in d["devices"].values() for x in v if x.get("isAvailable") and "iPhone" in x["name"]]; print(a[0]["udid"] if a else "")')
if [ -z "$DEVICE_ID" ]; then echo 'No hay un simulador iPhone disponible.'; exit 1; fi
xcrun simctl boot "$DEVICE_ID" || true
xcrun simctl bootstatus "$DEVICE_ID" -b
