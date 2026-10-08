#!/bin/bash
# Builds the screenshot-only copy of the app and the window lister into $WORK.
# The separate bundle ID gives the copy its own sandbox container, so captures never touch the real app's settings
# or history; the empty entitlements file is needed because the iCloud entitlement does not apply to that ID.
set -euo pipefail
TOOLS=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$TOOLS/../../.." && pwd)
WORK=${WORK:-${TMPDIR:-/tmp}/lockwatcher-shots}
mkdir -p "$WORK"

xcodebuild -project "$REPO/Lock-Watcher.xcodeproj" -scheme Lock-Watcher -configuration Debug \
  -destination platform=macOS -derivedDataPath "$WORK/dd" \
  PRODUCT_BUNDLE_IDENTIFIER=com.igrsoft.lockwatcher.shots \
  CODE_SIGN_ENTITLEMENTS="$TOOLS/shots.entitlements" \
  build > "$WORK/build.log" 2>&1 || { tail -30 "$WORK/build.log"; exit 1; }

swiftc -O "$TOOLS/wins.swift" -o "$WORK/wins"
echo "built $WORK/dd/Build/Products/Debug/Lock-Watcher.app"
