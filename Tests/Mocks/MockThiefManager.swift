//
//  MockThiefManager.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 23.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import Foundation

final class MockThiefManager: ThiefManagerProtocol {

    var invokedDatabaseManagerSetter = false
    var invokedDatabaseManagerSetterCount = 0
    var invokedDatabaseManager: (any DatabaseManagerProtocol)?
    var invokedDatabaseManagerList = [any DatabaseManagerProtocol]()
    var invokedDatabaseManagerGetter = false
    var invokedDatabaseManagerGetterCount = 0
    var stubbedDatabaseManager: (any DatabaseManagerProtocol)?

    var databaseManager: any DatabaseManagerProtocol {
        set {
            invokedDatabaseManagerSetter = true
            invokedDatabaseManagerSetterCount += 1
            invokedDatabaseManager = newValue
            invokedDatabaseManagerList.append(newValue)
        }
        get {
            invokedDatabaseManagerGetter = true
            invokedDatabaseManagerGetterCount += 1
            return stubbedDatabaseManager!
        }
    }

    var invokedDetectedTrigger = false
    var invokedDetectedTriggerCount = 0
    var invokedDetectedTriggerParameters: (closure: Commons.BoolClosure, Void)?
    var invokedDetectedTriggerParametersList = [(closure: Commons.BoolClosure, Void)]()

    func detectedTrigger(_ closure: @escaping Commons.BoolClosure) {
        invokedDetectedTrigger = true
        invokedDetectedTriggerCount += 1
        invokedDetectedTriggerParameters = (closure, ())
        invokedDetectedTriggerParametersList.append((closure, ()))
    }

    var invokedRestartWatching = false
    var invokedRestartWatchingCount = 0

    func restartWatching() {
        invokedRestartWatching = true
        invokedRestartWatchingCount += 1
    }

    var invokedSetupLocationManager = false
    var invokedSetupLocationManagerCount = 0
    var invokedSetupLocationManagerParameters: (enable: Bool, Void)?
    var invokedSetupLocationManagerParametersList = [(enable: Bool, Void)]()

    func setupLocationManager(enable: Bool) {
        invokedSetupLocationManager = true
        invokedSetupLocationManagerCount += 1
        invokedSetupLocationManagerParameters = (enable, ())
        invokedSetupLocationManagerParametersList.append((enable, ()))
    }

    var invokedShowSnapshot = false
    var invokedShowSnapshotCount = 0
    var invokedShowSnapshotParameters: (identifier: String, Void)?
    var invokedShowSnapshotParametersList = [(identifier: String, Void)]()

    func showSnapshot(identifier: String) {
        invokedShowSnapshot = true
        invokedShowSnapshotCount += 1
        invokedShowSnapshotParameters = (identifier, ())
        invokedShowSnapshotParametersList.append((identifier, ()))
    }

    var invokedCompleteDropboxAuthWith = false
    var invokedCompleteDropboxAuthWithCount = 0
    var invokedCompleteDropboxAuthWithParameters: (url: URL, Void)?
    var invokedCompleteDropboxAuthWithParametersList = [(url: URL, Void)]()

    func completeDropboxAuthWith(url: URL) {
        invokedCompleteDropboxAuthWith = true
        invokedCompleteDropboxAuthWithCount += 1
        invokedCompleteDropboxAuthWithParameters = (url, ())
        invokedCompleteDropboxAuthWithParametersList.append((url, ()))
    }

    var invokedWatchDropboxUserNameUpdate = false
    var invokedWatchDropboxUserNameUpdateCount = 0
    var invokedWatchDropboxUserNameUpdateParameters: (closure: Commons.StringClosure, Void)?
    var invokedWatchDropboxUserNameUpdateParametersList = [(closure: Commons.StringClosure, Void)]()

    func watchDropboxUserNameUpdate(_ closure: @escaping Commons.StringClosure) {
        invokedWatchDropboxUserNameUpdate = true
        invokedWatchDropboxUserNameUpdateCount += 1
        invokedWatchDropboxUserNameUpdateParameters = (closure, ())
        invokedWatchDropboxUserNameUpdateParametersList.append((closure, ()))
    }
}
