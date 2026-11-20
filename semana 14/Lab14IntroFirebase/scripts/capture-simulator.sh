#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence
DEVICE_ID=$(xcrun simctl list devices available -j | python3 -c 'import sys,json; d=json.load(sys.stdin); a=[x for v in d["devices"].values() for x in v if x.get("isAvailable") and "iPhone" in x["name"]]; print(a[0]["udid"] if a else "")')
if [ -z "$DEVICE_ID" ]; then echo "No hay un simulador iPhone disponible."; exit 1; fi
xcrun simctl boot "$DEVICE_ID" || true
xcrun simctl bootstatus "$DEVICE_ID" -b
xcrun simctl status_bar "$DEVICE_ID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
xcrun simctl install "$DEVICE_ID" .build-output/Build/Products/Debug-iphonesimulator/Lab14IntroFirebase.app
xcrun simctl launch "$DEVICE_ID" pe.edu.tecsup.dma.Lab14IntroFirebase
sleep 8
xcrun simctl io "$DEVICE_ID" screenshot evidence/01-inicio-real.png
echo 'Captura real de la pantalla inicial. No prueba registro ni mensajes.' > evidence/LEEME.txt
