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
    
    //MARK: - Dependency Injection
    
    var databaseManager: any DatabaseManagerProtocol
    
    //MARK: - Variables
    
    @Published var selectedItem: DatabaseDto?
    @Published var latestImages: [DatabaseDto] = .init()
    
    //MARK: - Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    init(databaseManager: any DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
                
        setupPublishers()
    }
    
    // MARK: Public Methods
    
    /// Action on press the close button on cell in list
    /// - Parameter dto: DatabaseDto from cell
    ///
    func remove(_ dto: DatabaseDto) {
        update(list: databaseManager.remove(dto).dtos)
    }
    
    // MARK: Private Methods
    
    /// Subscribe on changes
    ///
    private func setupPublishers() {
        // listen when new image has been added to database
        databaseManager.latestImagesPublisher.sink { [weak self] dtos in
            self?.update(list: dtos)
        }
        .store(in: &cancellables)
    }
    
    /// Clean old list and append sorted items by date to the list
    /// - Parameter list: DatabaseDto items
    ///
    private func update(list: [DatabaseDto]) {
        latestImages.removeAll()
        latestImages.append(contentsOf: list.sorted { $0.date > $1.date })
        selectedItem = latestImages.first
    }
}
