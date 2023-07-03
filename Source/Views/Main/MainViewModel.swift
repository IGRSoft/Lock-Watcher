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
    
    //MARK: - typealias
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    //MARK: - DomainViewConstantProtocol
    
    @Published var thiefManager: any ThiefManagerProtocol
    
    @Published var databaseManager: any DatabaseManagerProtocol
    
    //MARK: - Variables
    
    @Published var lastThiefDetectionViewModel: LastThiefDetectionViewModel
    
    @Published var isInfoExtended: Bool = false

    @Published var isAccessGranted = true
    
    var accessGrantedBlock: Commons.EmptyClosure?
    
    //MARK: - Initialise
    
    init(thiefManager: any ThiefManagerProtocol, isInfoExtended: Bool = false) {
        self.thiefManager = thiefManager
        self.databaseManager = thiefManager.databaseManager
        self.isInfoExtended = isInfoExtended
        self.lastThiefDetectionViewModel = LastThiefDetectionViewModel(databaseManager: thiefManager.databaseManager)
    }
}
