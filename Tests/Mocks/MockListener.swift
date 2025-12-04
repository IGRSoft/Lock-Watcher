//
//  MockListener.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
@testable import Lock_Watcher

final class MockListener: BaseListenerProtocol {
    var invokedListenerActionSetter = false
    var invokedListenerActionSetterCount = 0
    var invokedListenerAction: ListenerAction?
    var invokedListenerActionList = [ListenerAction?]()
    var invokedListenerActionGetter = false
    var invokedListenerActionGetterCount = 0
    var stubbedListenerAction: ListenerAction!

    var listenerAction: ListenerAction? {
        set {
            invokedListenerActionSetter = true
            invokedListenerActionSetterCount += 1
            invokedListenerAction = newValue
            invokedListenerActionList.append(newValue)
        }
        get {
            invokedListenerActionGetter = true
            invokedListenerActionGetterCount += 1
            return stubbedListenerAction
        }
    }

    var invokedIsRunningGetter = false
    var invokedIsRunningGetterCount = 0
    var stubbedIsRunning: Bool! = false

    var isRunning: Bool {
        invokedIsRunningGetter = true
        invokedIsRunningGetterCount += 1
        return stubbedIsRunning
    }

    var invokedStart = false
    var invokedStartCount = 0
    var stubbedStartActionResult: (ListenerName, TriggerType)?

    func start(_ action: @escaping ListenerAction) {
        invokedStart = true
        invokedStartCount += 1
        stubbedIsRunning = true
        if let result = stubbedStartActionResult {
            action(result.0, result.1)
        }
    }

    var invokedStop = false
    var invokedStopCount = 0

    func stop() {
        invokedStop = true
        invokedStopCount += 1
        stubbedIsRunning = false
    }
}
