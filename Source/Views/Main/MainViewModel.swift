//
//  MainViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 30.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

class MainViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    
    var viewSettings: MainDomain = .init()
    
    typealias DomainViewConstant = MainDomain
    
    //MARK: - Types
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    //MARK: - Dependency injection
    
    @Published var thiefManager: any ThiefManagerProtocol
    
    @Published var databaseManager: any DatabaseManagerProtocol
    
    //MARK: - Variables
    
    @Published var lastThiefDetectionViewModel: LastThiefDetectionViewModel
    
    @Published var isInfoExtended: Bool = true

    @Published var isAccessGranted = true
    
    var accessGrantedBlock: Commons.EmptyClosure?
    
    //MARK: - initialiser
    
    init(thiefManager: any ThiefManagerProtocol, isInfoExtended: Bool = true) {
        self.thiefManager = thiefManager
        self.databaseManager = thiefManager.databaseManager
        self.isInfoExtended = isInfoExtended
        self.lastThiefDetectionViewModel = LastThiefDetectionViewModel(databaseManager: thiefManager.databaseManager)
    }
}

extension MainViewModel {
    static var preview: MainViewModel = MainViewModel(thiefManager: ThiefManagerPreview())
}
