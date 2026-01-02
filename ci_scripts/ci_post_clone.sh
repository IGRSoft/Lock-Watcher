#!/bin/sh

set -e

cat <<EOF > "$CI_PRIMARY_REPOSITORY_PATH/Source/Application/Secrets.swift"
import Foundation

enum Secrets {
    static let soul = "${SECRETS_SOUL}"
    static let keychainId = "${SECRETS_KEYCHAIN_ID}"
    static let appKey = "${SECRETS_APP_KEY}"
    static let userDefaultsId = "${SECRETS_USER_DEFAULTS_ID}"
    static let dropboxKey = "${SECRETS_DROPBOX_KEY}"
}
EOF

echo "✅ Secrets.swift created"

defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution
