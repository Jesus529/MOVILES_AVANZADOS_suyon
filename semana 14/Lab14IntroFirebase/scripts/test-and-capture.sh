#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence
DEVICE_ID=$(xcrun simctl list devices booted -j | python3 -c 'import sys,json; d=json.load(sys.stdin); a=[x for v in d["devices"].values() for x in v if "iPhone" in x["name"] and x["state"]=="Booted"]; print(a[0]["udid"] if a else "")')
if [ -z "$DEVICE_ID" ]; then echo 'No hay un simulador iPhone iniciado.'; exit 1; fi
xcodebuild test \
  -project Lab14IntroFirebase.xcodeproj \
  -scheme Lab14IntroFirebase \
  -configuration Debug \
  -destination "platform=iOS Simulator,id=$DEVICE_ID,arch=$(uname -m)" \
  -parallel-testing-enabled NO \
  -only-testing:Lab14IntroFirebaseUITests/LaboratorioCapturasTests/testCapturarLaboratorioConDosUsuarios \
  -derivedDataPath .build-output \
  -resultBundlePath .build-output/Lab14.xcresult \
  ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=YES CODE_SIGN_IDENTITY=- 2>&1 | tee evidence/pruebas-ui.log
