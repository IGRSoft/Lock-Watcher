//
//  FirstLaunchViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Combine

/// The view model for the first launch view.
final class FirstLaunchViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    
    /// The view's domain-specific constants.
    var viewSettings: FirstLaunchDomain = .init()
    
    /// The type of domain-specific constants associated with this view.
    typealias DomainViewConstant = FirstLaunchDomain
    
    //MARK: - Dependency injection
    
    /// The application's settings.
    @Published private var settings: AppSettingsProtocol
    
    /// The manager responsible for handling "thief" related operations.
    @Published private var thiefManager: ThiefManagerProtocol
    
    /// The closure to close the view.
    private var closeClosure: Commons.EmptyClosure
    
    //MARK: - Variables
    
    /// The current state of the view.
    @Published private(set) var state: StateMode = .idle
    
    /// Countdown after success before closing the window.
    @Published private(set) var successCountDown = AppSettings.firstLaunchSuccessCount
    
    /// The safe area for the view.
    lazy var safeArea = CGSize(width: viewSettings.window.width - ViewConstants.padding, height: viewSettings.window.height - ViewConstants.padding)
    
    /// Indicates if a restart is needed.
    @Published var isNeedRestart: Bool = false
    
    /// Indicates if an alert should be shown.
    @Published var showingAlert = false
    
    /// A timer for tracking time-based operations.
    private var timer: Timer?
    
    /// View model for the first launch options.
    lazy var firstLaunchOptionsViewModel: FirstLaunchOptionsViewModel = {
        FirstLaunchOptionsViewModel(settings: settings)
    }()
    
    //MARK: - Combine
    
    /// Collection of cancellable publishers to clean up when done.
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initializer
    
    /// Initializes the view model with dependencies.
    init(settings: AppSettingsProtocol, thiefManager: ThiefManagerProtocol, closeClosure: @escaping Commons.EmptyClosure) {
        self.settings = settings
        self.thiefManager = thiefManager
        self.closeClosure = closeClosure
        
        setupPublishers()
    }
    
    /// Deinit cleans up any active timers.
    deinit {
        stopTimer()
    }
    
    /// Stops any active timers.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: - ViewBuilder Methods
    
    /// Provides the text for taking a snapshot.
    @ViewBuilder
    public func takeSnapshotTitle() -> Text {
        Text("TakeSnapshotAndStart")
    }
    
    /// Simulates taking a snapshot and starts a process.
    public func takeSnapshot() {
        state = .progress
    }
    
    /// Provides the title for the alert to open settings.
    @ViewBuilder
    public func openSettingsAlertTitle() -> Text {
        Text("OpenSettings")
    }
    
    /// Provides the button title to open settings.
    @ViewBuilder
    public func openSettingsTitle() -> Text {
        Text("ButtonSettings")
    }
    
    /// Opens the settings for the application.
    public func openSettings() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
    }
    
    /// Provides the cancel button title for the settings alert.
    @ViewBuilder
    public func cancelSettingsTitle() -> Text {
        Text("ButtonCancel")
    }
    
    /// Restarts the view to its initial state.
    @ViewBuilder
    public func restartView() -> some View {
        Text("")
            .onAppear() { [weak self] in
                self?.state = .idle
            }
    }
    
    //MARK: - Private Methods
    
    /// Sets up publishers for state changes.
    private func setupPublishers() {
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
    
    /// Simulates a trigger for permissions and state changes.
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
    
    /// Starts a timer to close the window after the success countdown is completed.
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

/// Provides a preview version of the `FirstLaunchViewModel`.
extension FirstLaunchViewModel {
    static var preview: FirstLaunchViewModel = FirstLaunchViewModel(settings: AppSettingsPreview(), thiefManager: ThiefManagerPreview(), closeClosure: {})
}
