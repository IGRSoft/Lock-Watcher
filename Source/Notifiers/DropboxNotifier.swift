//
//  DropboxNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2021.
//

import AppKit
import CoreLocation
@preconcurrency import SwiftyDropbox

/// An additional protocol to handle Dropbox authentication completion.
protocol DropboxNotifierProtocol {
    func completeDropboxAuthWith(url: URL) async -> String
}

/// A service responsible for handling and sending image notifications to Dropbox.
///
/// - Note: `@unchecked Sendable` is required because:
///   - `DropboxClient` from SwiftyDropbox is not marked `Sendable` but is thread-safe per SDK documentation
///   - The client is only accessed from async contexts with proper await boundaries
final class DropboxNotifier: NotifierProtocol, DropboxNotifierProtocol {
    // MARK: - Dependency injection

    /// Logger instance responsible for capturing and logging events or errors.
    private let logger: LogProtocol

    // MARK: - Variables

    /// A client to interact with the Dropbox API.
    /// - Note: Thread-safe per SwiftyDropbox SDK documentation.
    private var client: DropboxClient?

    // MARK: - Initializer

    /// Initializes a new instance of the `DropboxNotifier`.
    ///
    /// - Parameter logger: An optional logger instance for capturing and logging events.
    init(logger: LogProtocol = Log(category: .dropboxNotifier)) {
        self.logger = logger
        client = DropboxClientsManager.authorizedClient
    }

    // MARK: - Public methods

    /// Registers the notifier with the provided application settings.
    ///
    /// - Parameter settings: The application settings to configure the Dropbox notifier.
    func register(with settings: AppSettingsProtocol) {
        // Setup the Dropbox client with the application's key.
        DropboxClientsManager.setupWithAppKeyDesktop(Secrets.dropboxKey)
    }

    /// Sends an image notification based on the provided `ThiefDto` information.
    ///
    /// This function uploads the image with optional text derived from `thiefDto.description()`
    /// to Dropbox.
    ///
    /// - Parameter thiefDto: The data object containing the details to be saved as an image.
    /// - Throws: `NotifierError` if the upload fails.
    func send(_ thiefDto: ThiefDto) async throws {
        guard let filePath = thiefDto.filePath else {
            logger.error("wrong file path")
            throw NotifierError.invalidFilePath
        }

        var image = NSImage(contentsOf: filePath)
        let info = thiefDto.description()
        if !info.isEmpty {
            image = image?.imageWithText(text: info)
        }

        guard let data = image?.jpegData, !data.isEmpty else {
            throw NotifierError.emptyData
        }

        logger.debug("send: \(thiefDto)")

        guard let client else {
            throw NotifierError.authenticationRequired
        }

        let fileName = filePath.path.split(separator: "/").last.map(String.init) ?? "image.jpeg"

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            client.files.upload(path: "/\(fileName)", input: data)
                .response { [weak self] response, error in
                    if let response {
                        self?.logger.debug("\(response)")
                        continuation.resume()
                    } else if let error {
                        self?.logger.error("\(error)")
                        continuation.resume(throwing: NotifierError.uploadFailed(error as Error))
                    } else {
                        continuation.resume()
                    }
                }
                .progress { [weak self] progressData in
                    self?.logger.debug("progress: \(progressData)")
                }
        }
    }
    
    /// Initiates the Dropbox authentication flow.
    ///
    /// - Parameter controller: The view controller from which the authentication flow is started.
    @MainActor
    static func authorize(on controller: NSViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(sharedApplication: NSApplication.shared,
                                                        controller: controller,
                                                        loadingStatusDelegate: nil,
                                                        openURL: { url in NSWorkspace.shared.open(url) },
                                                        scopeRequest: scopeRequest)
    }
    
    /// Logs out from the currently authenticated Dropbox account.
    static func logout() {
        DropboxClientsManager.unlinkClients()
    }
    
    /// Handles the Dropbox authentication completion by using the provided URL.
    ///
    /// - Parameter url: The URL returned after completing the authentication flow.
    /// - Returns: The display name of the authenticated user, or empty string on failure.
    func completeDropboxAuthWith(url: URL) async -> String {
        await MainActor.run {
            NSApp.activate(ignoringOtherApps: true)
        }

        return await withCheckedContinuation { continuation in
            DropboxClientsManager.handleRedirectURL(url, includeBackgroundClient: false) { [weak self] authResult in
                switch authResult {
                case .success:
                    self?.client = DropboxClientsManager.authorizedClient
                    let currentAccount = self?.client?.users.getCurrentAccount()
                    currentAccount?.response { user, _ in
                        let displayName = user?.name.displayName ?? ""
                        continuation.resume(returning: displayName)
                    }
                case .cancel, .error:
                    continuation.resume(returning: "")
                case .none:
                    continuation.resume(returning: "")
                }
            }
        }
    }
}
