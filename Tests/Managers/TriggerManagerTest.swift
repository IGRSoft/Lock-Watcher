//
//  TriggerManagerTest.swift
//
//  Created on 01.01.2026.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

@MainActor
final class TriggerManagerTests: XCTestCase {
    var sut: TriggerManager!
    var mockLogger: LogMock!

    override func setUp() {
        super.setUp()
        mockLogger = LogMock()
        sut = TriggerManager(logger: mockLogger)
    }

    override func tearDown() {
        sut.stop()
        sut = nil
        mockLogger = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testTriggerManagerInit() {
        XCTAssertNotNil(sut)
    }

    // MARK: - Start Tests

    func testStartWithNilSettings() {
        nonisolated(unsafe) var triggerCalled = false

        sut.start(settings: nil) { _ in
            triggerCalled = true
        }

        // With nil settings, no triggers should be enabled
        XCTAssertFalse(triggerCalled)
    }

    func testStartWithPreviewSettings() {
        let settings = AppSettingsPreview()
        nonisolated(unsafe) var triggerCount = 0

        sut.start(settings: settings) { _ in
            triggerCount += 1
        }

        // Verify debug log was called
        XCTAssertNotNil(mockLogger.debugMessage)
        XCTAssertTrue(mockLogger.debugMessage?.contains("Starting") ?? false)
    }

    func testStartWithAllTriggersDisabled() {
        let settings = AppSettingsPreview()
        settings.triggers.isUseSnapshotOnWakeUp = false
        settings.triggers.isUseSnapshotOnLogin = false
        settings.triggers.isUseSnapshotOnWrongPassword = false
        settings.triggers.isUseSnapshotOnSwitchToBatteryPower = false
        settings.triggers.isUseSnapshotOnUSBMount = false

        sut.start(settings: settings) { _ in }

        // Manager should still initialize without crashing
        XCTAssertNotNil(sut)
    }

    func testStartWithWakeUpTriggerEnabled() {
        let settings = AppSettingsPreview()
        settings.triggers.isUseSnapshotOnWakeUp = true
        settings.triggers.isUseSnapshotOnLogin = false

        sut.start(settings: settings) { _ in }

        // Verify the manager started
        XCTAssertNotNil(mockLogger.debugMessage)
    }

    func testStartWithLoginTriggerEnabled() {
        let settings = AppSettingsPreview()
        settings.triggers.isUseSnapshotOnWakeUp = false
        settings.triggers.isUseSnapshotOnLogin = true

        sut.start(settings: settings) { _ in }

        XCTAssertNotNil(mockLogger.debugMessage)
    }

    func testStartWithBatteryPowerTriggerEnabled() {
        let settings = AppSettingsPreview()
        settings.triggers.isUseSnapshotOnWakeUp = false
        settings.triggers.isUseSnapshotOnLogin = false
        settings.triggers.isUseSnapshotOnSwitchToBatteryPower = true

        sut.start(settings: settings) { _ in }

        XCTAssertNotNil(mockLogger.debugMessage)
    }

    func testStartWithUSBMountTriggerEnabled() {
        let settings = AppSettingsPreview()
        settings.triggers.isUseSnapshotOnWakeUp = false
        settings.triggers.isUseSnapshotOnLogin = false
        settings.triggers.isUseSnapshotOnUSBMount = true

        sut.start(settings: settings) { _ in }

        XCTAssertNotNil(mockLogger.debugMessage)
    }

    // MARK: - Stop Tests

    func testStop() {
        let settings = AppSettingsPreview()
        sut.start(settings: settings) { _ in }

        sut.stop()

        // Verify stop was logged
        XCTAssertTrue(mockLogger.debugMessage?.contains("Stop") ?? false)
    }

    func testStopWithoutStart() {
        // Should not crash when stopping without starting
        sut.stop()

        XCTAssertTrue(mockLogger.debugMessage?.contains("Stop") ?? false)
    }

    func testRestartAfterStop() {
        let settings = AppSettingsPreview()

        sut.start(settings: settings) { _ in }
        sut.stop()
        sut.start(settings: settings) { _ in }

        // Should be able to restart after stopping
        XCTAssertNotNil(sut)
    }

    // MARK: - Multiple Starts Tests

    func testMultipleStarts() {
        let settings = AppSettingsPreview()

        sut.start(settings: settings) { _ in }
        sut.start(settings: settings) { _ in }

        // Should handle multiple starts gracefully
        XCTAssertNotNil(sut)
    }

    // MARK: - Protocol Conformance Tests

    func testTriggerManagerConformsToProtocol() {
        let manager: TriggerManagerProtocol = sut

        XCTAssertNotNil(manager)
    }
}

// MARK: - Mock Settings for Testing

final class MockAppSettings: AppSettingsProtocol {
    static let isMASBuild: Bool = true
    static let isImageCaptureDebug: Bool = false
    static let firstLaunchSuccessCount: Int = 15

    var options: OptionsSettings
    var triggers: TriggerSettings
    var sync: SyncSettings
    var ui: UISettings

    init(
        options: OptionsSettings = .init(),
        triggers: TriggerSettings = .init(),
        sync: SyncSettings = .init(),
        ui: UISettings = .init()
    ) {
        self.options = options
        self.triggers = triggers
        self.sync = sync
        self.ui = ui
    }

    func resetToDefaults() {
        options = OptionsSettings()
        triggers = TriggerSettings()
        sync = SyncSettings()
        ui = UISettings()
    }

    static func withAllTriggersEnabled() -> MockAppSettings {
        var triggers = TriggerSettings()
        triggers.isUseSnapshotOnWakeUp = true
        triggers.isUseSnapshotOnLogin = true
        triggers.isUseSnapshotOnWrongPassword = true
        triggers.isUseSnapshotOnSwitchToBatteryPower = true
        triggers.isUseSnapshotOnUSBMount = true
        return MockAppSettings(triggers: triggers)
    }

    static func withNoTriggersEnabled() -> MockAppSettings {
        var triggers = TriggerSettings()
        triggers.isUseSnapshotOnWakeUp = false
        triggers.isUseSnapshotOnLogin = false
        triggers.isUseSnapshotOnWrongPassword = false
        triggers.isUseSnapshotOnSwitchToBatteryPower = false
        triggers.isUseSnapshotOnUSBMount = false
        return MockAppSettings(triggers: triggers)
    }
}
