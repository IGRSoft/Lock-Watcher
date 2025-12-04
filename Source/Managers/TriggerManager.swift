//
//  TriggerManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

/// MainActor-isolated trigger closure type
typealias MainActorTriggerClosure = @MainActor (TriggerType) -> Void

/// Defines a protocol for trigger management.
///
/// - Important: All trigger managers are `@MainActor` isolated because they
///   interact with `@MainActor` listeners and UI callbacks.
@MainActor
protocol TriggerManagerProtocol: Sendable {
    /// Starts the trigger manager with given settings and an optional trigger block.
    func start(settings: AppSettingsProtocol?, triggerBlock: @escaping MainActorTriggerClosure)

    /// Stops all running triggers.
    func stop()
}

/// Manages trigger listeners and coordinates event dispatching.
///
/// This class is `@MainActor` isolated because it manages `@MainActor` listeners
/// and dispatches callbacks to the main thread.
@MainActor
final class TriggerManager: TriggerManagerProtocol {
    // MARK: - Dependency injection

    /// Holds the application settings.
    private var settings: AppSettingsProtocol?

    /// Logger for module
    private let logger: LogProtocol

    /// The trigger block to call when events occur.
    private var triggerBlock: MainActorTriggerClosure?

    private let lockDetector: MacOSLockDetectorProtocol = MacOSLockDetector()

    /// Tasks consuming listener streams.
    private var listenerTasks: [ListenerName: Task<Void, Never>] = [:]

    /// Holds a set of listeners that are configured based on certain conditions.
    private lazy var listeners: [ListenerName: BaseListenerProtocol] = {
        var listeners: [ListenerName: BaseListenerProtocol] = [
            .onWakeUpListener: WakeUpListener(),
            .onBatteryPowerListener: PowerListener(),
            .onUSBConnectionListener: USBListener(),
            .onLoginListener: LoginListener(lockDetector: lockDetector)
        ]

        if !AppSettings.isMASBuild {
            listeners[.onWrongPassword] = WrongPasswordListener()
        }

        return listeners
    }()

    /// Initializer that configures the logger.
    init(logger: LogProtocol = Log(category: .triggerManager)) {
        self.logger = logger
    }

    // MARK: - public

    /// Starts all listeners based on provided settings.
    func start(settings: AppSettingsProtocol?, triggerBlock: @escaping MainActorTriggerClosure = { _ in }) {
        logger.debug("Starting all triggers")

        self.settings = settings
        self.triggerBlock = triggerBlock

        startListener(.onWakeUpListener, enabled: settings?.triggers.isUseSnapshotOnWakeUp == true)
        startListener(.onWrongPassword, enabled: settings?.triggers.isUseSnapshotOnWrongPassword == true)
        startListener(.onBatteryPowerListener, enabled: settings?.triggers.isUseSnapshotOnSwitchToBatteryPower == true)
        startListener(.onUSBConnectionListener, enabled: settings?.triggers.isUseSnapshotOnUSBMount == true)
        startListener(.onLoginListener, enabled: settings?.triggers.isUseSnapshotOnLogin == true)
    }

    /// Stops all active listeners.
    func stop() {
        logger.debug("Stop all triggers")

        for (_, task) in listenerTasks {
            task.cancel()
        }
        listenerTasks.removeAll()

        for listener in listeners.values {
            listener.stop()
        }
    }

    // MARK: - private

    private func startListener(_ name: ListenerName, enabled: Bool) {
        guard let listener = listeners[name] else { return }

        if enabled {
            if !listener.isRunning {
                let stream = listener.start()
                let task = Task { [weak self] in
                    for await (listenerName, triggerType) in stream {
                        // Already on MainActor, call directly
                        if triggerType != .onACPower {
                            self?.triggerBlock?(triggerType)
                        }
                        self?.restartListener(type: listenerName)
                    }
                }
                listenerTasks[name] = task
            }
        } else if listener.isRunning {
            listenerTasks[name]?.cancel()
            listenerTasks[name] = nil
            listener.stop()
        }
    }

    /// Restarts a listener based on its type.
    private func restartListener(type: ListenerName) {
        listenerTasks[type]?.cancel()
        listenerTasks[type] = nil

        if let l = listeners[type] {
            l.stop()
        }

        let listener: BaseListenerProtocol = switch type {
        case .onWakeUpListener: WakeUpListener()
        case .onWrongPassword: WrongPasswordListener()
        case .onBatteryPowerListener: PowerListener()
        case .onUSBConnectionListener: USBListener()
        case .onLoginListener: LoginListener(lockDetector: lockDetector)
        }

        listeners[type] = listener
        startListener(type, enabled: true)
    }
}
