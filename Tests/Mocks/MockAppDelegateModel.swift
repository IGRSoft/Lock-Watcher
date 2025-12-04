//
//  MockAppDelegateModel.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

final class MockAppDelegateModel: AppDelegateModelProtocol {
    var invokedSettingsViewGetter = false
    var invokedSettingsViewGetterCount = 0
    var stubbedSettingsView: SettingsView!

    var settingsView: SettingsView {
        invokedSettingsViewGetter = true
        invokedSettingsViewGetterCount += 1
        return stubbedSettingsView
    }

    var invokedSetup = false
    var invokedSetupCount = 0
    var invokedSetupParameters: (localNotification: Notification, Void)?
    var invokedSetupParametersList = [(localNotification: Notification, Void)]()

    func setup(with localNotification: Notification) {
        invokedSetup = true
        invokedSetupCount += 1
        invokedSetupParameters = (localNotification, ())
        invokedSetupParametersList.append((localNotification, ()))
    }

    var invokedCheckDropboxAuth = false
    var invokedCheckDropboxAuthCount = 0
    var invokedCheckDropboxAuthParameters: (urls: [URL], Void)?
    var invokedCheckDropboxAuthParametersList = [(urls: [URL], Void)]()
    var stubbedCheckDropboxAuthResult: Bool! = false

    func checkDropboxAuth(urls: [URL]) -> Bool {
        invokedCheckDropboxAuth = true
        invokedCheckDropboxAuthCount += 1
        invokedCheckDropboxAuthParameters = (urls, ())
        invokedCheckDropboxAuthParametersList.append((urls, ()))
        return stubbedCheckDropboxAuthResult
    }
}
