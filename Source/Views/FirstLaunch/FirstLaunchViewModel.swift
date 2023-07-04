//
//  FirstLaunchViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Combine

final class FirstLaunchViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    
    var viewSettings: FirstLaunchDomain = .init()
    
    typealias DomainViewConstant = FirstLaunchDomain
    
    //MARK: - Dependency injection
    
    @Published private var settings: any AppSettingsProtocol
    @Published private var thiefManager: any ThiefManagerProtocol
    
    private var closeClosure: Commons.EmptyClosure
    
    //MARK: - Variables
    
    @Published private(set) var state: StateMode = .idle
    @Published private(set) var successCountDown = AppSettings.firstLaunchSuccessCount
    
    lazy var safeArea = CGSize(width: viewSettings.window.width - ViewConstants.padding, height: viewSettings.window.height - ViewConstants.padding)
    
    @Published var isNeedRestart: Bool = false
    
    @Published var showingAlert = false
    
    private var timer: Timer?

    lazy var firstLaunchOptionsViewModel: FirstLaunchOptionsViewModel = {
        FirstLaunchOptionsViewModel(settings: settings)
    }()
    
    //MARK: - Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - initialiser
    
    init(settings: any AppSettingsProtocol, thiefManager: any ThiefManagerProtocol, closeClosure: @escaping Commons.EmptyClosure) {
        self.settings = settings
        self.thiefManager = thiefManager
        self.closeClosure = closeClosure
        
        setupPublishers()
    }
    
    deinit {
        stopTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: - ViewBuilder
    
    @ViewBuilder
    public func takeSnapshotTitle() -> Text {
        Text("TakeSnapshotAndStart")
    }
    
    public func takeSnapshot() {
        state = .progress
    }
    
    @ViewBuilder
    public func openSettingsAlertTitle() -> Text {
        Text("OpenSettings")
    }
    
    @ViewBuilder
    public func openSettingsTitle() -> Text {
        Text("ButtonSettings")
    }
    
    public func openSettings() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
    }
    
    @ViewBuilder
    public func cancelSettingsTitle() -> Text {
        Text("ButtonCancel")
    }
    
    @ViewBuilder
    public func restartView() -> some View {
        Text("")
            .onAppear() { [weak self] in
                self?.state = .idle
            }
    }
    
    //MARK: - private
    
    private func setupPublishers() {
        // listen when new image has been added to database
        $state.sink { [weak self] state in
            switch state {
            case .idle:
                self?.isNeedRestart = false
            case .progress:
                self?.simulateTrigger()
            case .success:
                self?.startTimerToCloseWindow()
            case .fault:
                self?.showingAlert = true
            case .anonymous, .authorised:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    private func simulateTrigger() {
        Task {
            PermissionsUtils.updateCameraPermissions { [weak self] isGranted in
                if isGranted {
                    self?.thiefManager.detectedTrigger() { success in
                        DispatchQueue.main.async { [weak self] in
                            self?.state = success ? .success : .fault
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .fault
                    }
                }
            }
        }
    }
    
    private func startTimerToCloseWindow() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            if successCountDown == .zero {
                timer.invalidate()
                closeClosure()
            } else {
                successCountDown -= 1
            }
        }
    }
}

extension FirstLaunchViewModel {
    static var preview: FirstLaunchViewModel = FirstLaunchViewModel(settings: AppSettingsPreview(), thiefManager: ThiefManagerPreview(), closeClosure: {})
}
