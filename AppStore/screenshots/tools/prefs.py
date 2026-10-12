"""Writes the app's JSON-encoded settings groups into the screenshot-only defaults plist."""
import json, plistlib, sys, time

path, ui = sys.argv[1], sys.argv[2]
expand = {
    "sec":  dict(isSecurityInfoExpand=True,  isSnapshotInfoExpand=False, isOptionsInfoExpand=False, isSyncInfoExpand=False),
    "snap": dict(isSecurityInfoExpand=False, isSnapshotInfoExpand=True,  isOptionsInfoExpand=False, isSyncInfoExpand=False),
    "opts": dict(isSecurityInfoExpand=False, isSnapshotInfoExpand=False, isOptionsInfoExpand=True,  isSyncInfoExpand=False),
    "sync": dict(isSecurityInfoExpand=False, isSnapshotInfoExpand=False, isOptionsInfoExpand=False, isSyncInfoExpand=True),
    "all":  dict(isSecurityInfoExpand=True,  isSnapshotInfoExpand=True,  isOptionsInfoExpand=True,  isSyncInfoExpand=True),
}[ui]
apple_ref = 978307200
groups = {
    "OptionsSettings": dict(isFirstLaunch=False, keepLastActionsCount=10, isSaveSnapshotToDisk=False,
                            addLocationToSnapshot=True, addIPAddressToSnapshot=True, addTraceRouteToSnapshot=False,
                            traceRouteServer="", isProtected=False,
                            authSettings=dict(biometrics=False, watch=False, devicePassword=False)),
    "TriggerSettings": dict(isUseSnapshotOnWakeUp=True, isUseSnapshotOnLogin=True, isUseSnapshotOnWrongPassword=False,
                            isUseSnapshotOnSwitchToBatteryPower=False, isUseSnapshotOnUSBMount=True,
                            isUseSnapshotOnDisplayAttach=True, isUseSnapshotOnLocationChange=True,
                            isUseSnapshotOnLockedInput=True, lockedInputDelay=5),
    "SyncSettings": dict(isSaveSnapshotToDisk=False, isSendNotificationToMail=False, mailRecipient="",
                         isICloudSyncEnable=True, isDropboxEnable=False, dropboxName="",
                         isUseSnapshotLocalNotification=True),
    "SnapshotSettings": dict(outputType="photo", videoDuration=3, quality=75),
    "RetentionSettings": dict(keepFiles="oneWeek", startDate=time.time() - 86400 * 30 - apple_ref, isUpgradeNoticeShown=True),
    "UISettings": expand,
}
data = {k: json.dumps(v).encode() for k, v in groups.items()}
with open(path, "wb") as f:
    plistlib.dump(data, f)
