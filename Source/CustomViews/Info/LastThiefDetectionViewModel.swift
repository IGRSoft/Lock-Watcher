//
//  LastThiefDetectionViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Combine

class LastThiefDetectionViewModel: ObservableObject {
    var databaseManager: any DatabaseManagerProtocol
    
    @Published var isPreviewActive: Bool = false
    @Published var isUnlocked = false
    
    @Published var selectedItem: DatabaseDto?
    @Published var latestImages: [DatabaseDto] = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(databaseManager: any DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
                
        setupPublishers()
    }
    
    private func setupPublishers() {
        databaseManager.latestImagesPublisher.sink { [weak self] dtos in
            self?.update(list: dtos)
        }
        .store(in: &cancellables)
    }
    
    func remove(_ dto: DatabaseDto) {
        update(list: databaseManager.remove(dto).dtos)
    }
    
    private func update(list: [DatabaseDto]) {
        latestImages.removeAll()
        latestImages.append(contentsOf: list)
        selectedItem = latestImages.first
    }
}
