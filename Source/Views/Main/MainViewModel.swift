//
//  MainViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 30.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view model for the main screen, handling business logic and data retrieval for its corresponding view.
class MainViewModel: ObservableObject, DomainViewConstantProtocol {
    
    // MARK: - DomainViewConstantProtocol
    
    /// Configuration settings specific to the main view.
    var viewSettings: MainDomain = .init()
    
    /// A typealias for easier reference.
    typealias DomainViewConstant = MainDomain
    
    // MARK: - Types
    
    /// A typealias to represent a callback block which is triggered based on some event.
    typealias SettingsTriggerWatchBlock = Commons.TriggerClosure
    
    // MARK: - Dependency injection
    
    /// The manager responsible for operations related to potential security threats.
    @Published var thiefManager: ThiefManagerProtocol
    
    /// The manager responsible for database operations.
    @Published var databaseManager: any DatabaseManagerProtocol
    
    // MARK: - Variables
    
    /// The view model responsible for displaying the last detected thief information.
    @Published var lastThiefDetectionViewModel: LastThiefDetectionViewModel
    
    /// A boolean that denotes if additional information should be displayed on the main screen.
    @Published var isInfoExtended: Bool = true
    
    /// A boolean that represents whether the required access permissions are granted or not.
    @Published var isAccessGranted = true
    
    /// A callback block that is invoked when the required access permissions are granted.
    var accessGrantedBlock: Commons.EmptyClosure?
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `MainViewModel`.
    /// - Parameters:
    ///   - thiefManager: An object conforming to `ThiefManagerProtocol` to manage potential security threats.
    ///   - isInfoExtended: A boolean value to indicate if the information should be extended. Default value is `true`.
    init(thiefManager: ThiefManagerProtocol, isInfoExtended: Bool = true) {
        self.thiefManager = thiefManager
        self.databaseManager = thiefManager.databaseManager
        self.isInfoExtended = isInfoExtended
        self.lastThiefDetectionViewModel = LastThiefDetectionViewModel(databaseManager: thiefManager.databaseManager)
    }
}

/// An extension providing a preview instance of `MainViewModel` for design and testing purposes.
extension MainViewModel {
    static var preview: MainViewModel = MainViewModel(thiefManager: ThiefManagerPreview())
}
