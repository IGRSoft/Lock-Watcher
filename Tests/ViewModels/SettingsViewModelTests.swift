//
//  SettingsViewModelTests.swift
//
//  Created on 03.01.2026.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Combine
import SwiftUI
import XCTest
@testable import Lock_Watcher

@MainActor
final class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!
    private var mockSettings: AppSettingsPreview!
    private var mockThiefManager: MockThiefManager!

    override func setUp() async throws {
        try await super.setUp()
        mockSettings = AppSettingsPreview()
        mockThiefManager = MockThiefManager()
        mockThiefManager.stubbedDatabaseManager = MockDatabaseManager()
        sut = SettingsViewModel(settings: mockSettings, thiefManager: mockThiefManager)
    }

    override func tearDown() async throws {
        sut = nil
        mockThiefManager = nil
        mockSettings = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialization() {
        XCTAssertNotNil(sut)
    }

    func testInitialIsInfoHidden() {
        XCTAssertTrue(sut.isInfoHidden)
    }

    func testInitialIsAccessGranted() {
        XCTAssertTrue(sut.isAccessGranted)
    }

    func testViewSettingsExists() {
        XCTAssertNotNil(sut.viewSettings)
    }

    // MARK: - UI Bindings Tests

    func testIsSecurityInfoExpandBindingReads() {
        mockSettings.ui.isSecurityInfoExpand = true
        XCTAssertTrue(sut.isSecurityInfoExpand.wrappedValue)

        mockSettings.ui.isSecurityInfoExpand = false
        XCTAssertFalse(sut.isSecurityInfoExpand.wrappedValue)
    }

    func testIsSecurityInfoExpandBindingWrites() {
        sut.isSecurityInfoExpand.wrappedValue = false
        XCTAssertFalse(mockSettings.ui.isSecurityInfoExpand)

        sut.isSecurityInfoExpand.wrappedValue = true
        XCTAssertTrue(mockSettings.ui.isSecurityInfoExpand)
    }

    func testIsSnapshotInfoExpandBindingReads() {
        mockSettings.ui.isSnapshotInfoExpand = true
        XCTAssertTrue(sut.isSnapshotInfoExpand.wrappedValue)
    }

    func testIsSnapshotInfoExpandBindingWrites() {
        sut.isSnapshotInfoExpand.wrappedValue = true
        XCTAssertTrue(mockSettings.ui.isSnapshotInfoExpand)
    }

    func testIsOptionsInfoExpandBindingReads() {
        mockSettings.ui.isOptionsInfoExpand = true
        XCTAssertTrue(sut.isOptionsInfoExpand.wrappedValue)
    }

    func testIsOptionsInfoExpandBindingWrites() {
        sut.isOptionsInfoExpand.wrappedValue = true
        XCTAssertTrue(mockSettings.ui.isOptionsInfoExpand)
    }

    func testIsSyncInfoExpandBindingReads() {
        mockSettings.ui.isSyncInfoExpand = true
        XCTAssertTrue(sut.isSyncInfoExpand.wrappedValue)
    }

    func testIsSyncInfoExpandBindingWrites() {
        sut.isSyncInfoExpand.wrappedValue = false
        XCTAssertFalse(mockSettings.ui.isSyncInfoExpand)
    }

    // MARK: - Protection Bindings Tests

    func testIsProtectedBindingReads() {
        mockSettings.options.isProtected = true
        XCTAssertTrue(sut.isProtected.wrappedValue)
    }

    func testIsProtectedBindingWrites() {
        sut.isProtected.wrappedValue = true
        XCTAssertTrue(mockSettings.options.isProtected)
    }

    func testAuthSettingsBindingReads() {
        mockSettings.options.authSettings = .biometricsOrWatch
        XCTAssertEqual(sut.authSettings.wrappedValue, .biometricsOrWatch)
    }

    func testAuthSettingsBindingWrites() {
        sut.authSettings.wrappedValue = .biometricsOrWatch
        XCTAssertEqual(mockSettings.options.authSettings, .biometricsOrWatch)
    }

    // MARK: - Trigger Bindings Tests

    func testIsUseSnapshotOnWakeUpBindingReads() {
        mockSettings.triggers.isUseSnapshotOnWakeUp = true
        XCTAssertTrue(sut.isUseSnapshotOnWakeUp.wrappedValue)
    }

    func testIsUseSnapshotOnWakeUpBindingWrites() {
        sut.isUseSnapshotOnWakeUp.wrappedValue = false
        XCTAssertFalse(mockSettings.triggers.isUseSnapshotOnWakeUp)
    }

    func testIsUseSnapshotOnLoginBindingReads() {
        mockSettings.triggers.isUseSnapshotOnLogin = true
        XCTAssertTrue(sut.isUseSnapshotOnLogin.wrappedValue)
    }

    func testIsUseSnapshotOnLoginBindingWrites() {
        sut.isUseSnapshotOnLogin.wrappedValue = false
        XCTAssertFalse(mockSettings.triggers.isUseSnapshotOnLogin)
    }

    func testIsUseSnapshotOnWrongPasswordBindingReads() {
        mockSettings.triggers.isUseSnapshotOnWrongPassword = true
        XCTAssertTrue(sut.isUseSnapshotOnWrongPassword.wrappedValue)
    }

    func testIsUseSnapshotOnWrongPasswordBindingWrites() {
        sut.isUseSnapshotOnWrongPassword.wrappedValue = true
        XCTAssertTrue(mockSettings.triggers.isUseSnapshotOnWrongPassword)
    }

    func testIsUseSnapshotOnSwitchToBatteryPowerBindingReads() {
        mockSettings.triggers.isUseSnapshotOnSwitchToBatteryPower = true
        XCTAssertTrue(sut.isUseSnapshotOnSwitchToBatteryPower.wrappedValue)
    }

    func testIsUseSnapshotOnSwitchToBatteryPowerBindingWrites() {
        sut.isUseSnapshotOnSwitchToBatteryPower.wrappedValue = true
        XCTAssertTrue(mockSettings.triggers.isUseSnapshotOnSwitchToBatteryPower)
    }

    func testIsUseSnapshotOnUSBMountBindingReads() {
        mockSettings.triggers.isUseSnapshotOnUSBMount = true
        XCTAssertTrue(sut.isUseSnapshotOnUSBMount.wrappedValue)
    }

    func testIsUseSnapshotOnUSBMountBindingWrites() {
        sut.isUseSnapshotOnUSBMount.wrappedValue = true
        XCTAssertTrue(mockSettings.triggers.isUseSnapshotOnUSBMount)
    }

    // MARK: - Options Bindings Tests

    func testKeepLastActionsCountBindingReads() {
        mockSettings.options.keepLastActionsCount = 20
        XCTAssertEqual(sut.keepLastActionsCount.wrappedValue, 20)
    }

    func testKeepLastActionsCountBindingWrites() {
        sut.keepLastActionsCount.wrappedValue = 15
        XCTAssertEqual(mockSettings.options.keepLastActionsCount, 15)
    }

    func testAddLocationToSnapshotBindingReads() {
        mockSettings.options.addLocationToSnapshot = true
        XCTAssertTrue(sut.addLocationToSnapshot.wrappedValue)
    }

    func testAddLocationToSnapshotBindingWrites() {
        sut.addLocationToSnapshot.wrappedValue = true
        XCTAssertTrue(mockSettings.options.addLocationToSnapshot)
    }

    func testAddIPAddressToSnapshotBindingReads() {
        mockSettings.options.addIPAddressToSnapshot = true
        XCTAssertTrue(sut.addIPAddressToSnapshot.wrappedValue)
    }

    func testAddIPAddressToSnapshotBindingWrites() {
        sut.addIPAddressToSnapshot.wrappedValue = true
        XCTAssertTrue(mockSettings.options.addIPAddressToSnapshot)
    }

    func testAddTraceRouteToSnapshotBindingReads() {
        mockSettings.options.addTraceRouteToSnapshot = true
        XCTAssertTrue(sut.addTraceRouteToSnapshot.wrappedValue)
    }

    func testAddTraceRouteToSnapshotBindingWrites() {
        sut.addTraceRouteToSnapshot.wrappedValue = true
        XCTAssertTrue(mockSettings.options.addTraceRouteToSnapshot)
    }

    func testTraceRouteServerBindingReads() {
        mockSettings.options.traceRouteServer = "test.server.com"
        XCTAssertEqual(sut.traceRouteServer.wrappedValue, "test.server.com")
    }

    func testTraceRouteServerBindingWrites() {
        sut.traceRouteServer.wrappedValue = "new.server.com"
        XCTAssertEqual(mockSettings.options.traceRouteServer, "new.server.com")
    }

    // MARK: - Sync Bindings Tests

    func testIsSaveSnapshotToDiskBindingReads() {
        mockSettings.sync.isSaveSnapshotToDisk = true
        XCTAssertTrue(sut.isSaveSnapshotToDisk.wrappedValue)
    }

    func testIsSaveSnapshotToDiskBindingWrites() {
        sut.isSaveSnapshotToDisk.wrappedValue = true
        XCTAssertTrue(mockSettings.sync.isSaveSnapshotToDisk)
    }

    func testIsSendNotificationToMailBindingReads() {
        mockSettings.sync.isSendNotificationToMail = true
        XCTAssertTrue(sut.isSendNotificationToMail.wrappedValue)
    }

    func testIsSendNotificationToMailBindingWrites() {
        sut.isSendNotificationToMail.wrappedValue = true
        XCTAssertTrue(mockSettings.sync.isSendNotificationToMail)
    }

    func testMailRecipientBindingReads() {
        mockSettings.sync.mailRecipient = "test@example.com"
        XCTAssertEqual(sut.mailRecipient.wrappedValue, "test@example.com")
    }

    func testMailRecipientBindingWrites() {
        sut.mailRecipient.wrappedValue = "new@example.com"
        XCTAssertEqual(mockSettings.sync.mailRecipient, "new@example.com")
    }

    func testIsICloudSyncEnableBindingReads() {
        mockSettings.sync.isICloudSyncEnable = true
        XCTAssertTrue(sut.isICloudSyncEnable.wrappedValue)
    }

    func testIsICloudSyncEnableBindingWrites() {
        sut.isICloudSyncEnable.wrappedValue = true
        XCTAssertTrue(mockSettings.sync.isICloudSyncEnable)
    }

    func testIsDropboxEnableBindingReads() {
        mockSettings.sync.isDropboxEnable = true
        XCTAssertTrue(sut.isDropboxEnable.wrappedValue)
    }

    func testIsDropboxEnableBindingWrites() {
        sut.isDropboxEnable.wrappedValue = true
        XCTAssertTrue(mockSettings.sync.isDropboxEnable)
    }

    func testDropboxNameBindingReads() {
        mockSettings.sync.dropboxName = "TestUser"
        XCTAssertEqual(sut.dropboxName.wrappedValue, "TestUser")
    }

    func testDropboxNameBindingWrites() {
        sut.dropboxName.wrappedValue = "NewUser"
        XCTAssertEqual(mockSettings.sync.dropboxName, "NewUser")
    }

    func testIsUseSnapshotLocalNotificationBindingReads() {
        mockSettings.sync.isUseSnapshotLocalNotification = true
        XCTAssertTrue(sut.isUseSnapshotLocalNotification.wrappedValue)
    }

    func testIsUseSnapshotLocalNotificationBindingWrites() {
        sut.isUseSnapshotLocalNotification.wrappedValue = true
        XCTAssertTrue(mockSettings.sync.isUseSnapshotLocalNotification)
    }

    // MARK: - ThiefManager Delegation Tests

    func testRestartWatchingCallsThiefManager() {
        sut.restartWatching()
        XCTAssertTrue(mockThiefManager.invokedRestartWatching)
        XCTAssertEqual(mockThiefManager.invokedRestartWatchingCount, 1)
    }

    func testSetupLocationManagerCallsThiefManager() {
        sut.setupLocationManager(enable: true)
        XCTAssertTrue(mockThiefManager.invokedSetupLocationManager)
        XCTAssertEqual(mockThiefManager.invokedSetupLocationManagerParameters?.enable, true)
    }

    func testSetupLocationManagerWithFalseCallsThiefManager() {
        sut.setupLocationManager(enable: false)
        XCTAssertTrue(mockThiefManager.invokedSetupLocationManager)
        XCTAssertEqual(mockThiefManager.invokedSetupLocationManagerParameters?.enable, false)
    }

    // MARK: - Access Granted Block Tests

    func testAccessGrantedBlockIsInitiallyNil() {
        XCTAssertNil(sut.accessGrantedBlock)
    }

    func testAccessGrantedBlockCanBeSet() {
        var wasCalled = false
        sut.accessGrantedBlock = {
            wasCalled = true
        }

        XCTAssertNotNil(sut.accessGrantedBlock)
        sut.accessGrantedBlock?()
        XCTAssertTrue(wasCalled)
    }

    // MARK: - Preview Tests

    func testPreviewInstanceExists() {
        let preview = SettingsViewModel.preview
        XCTAssertNotNil(preview)
    }

    // MARK: - Dropbox Username Update Tests

    func testDropboxUserNameUpdateChangesSettings() async throws {
        // Emit a new username
        mockThiefManager.emitDropboxUserName("UpdatedUser")

        // Wait for async update
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        XCTAssertEqual(mockSettings.sync.dropboxName, "UpdatedUser")
    }
}
