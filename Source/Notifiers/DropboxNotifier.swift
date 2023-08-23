//
//  DropboxNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2021.
//

import AppKit
import CoreLocation
import SwiftyDropbox

/// An additional protocol to handle Dropbox authentication completion.
protocol DropboxNotifierProtocol {
    func completeDropboxAuthWith(url: URL, completionHandler handler: @escaping Commons.StringClosure)
}

/// A service responsible for handling and sending image notifications to Dropbox.
final class DropboxNotifier: NotifierProtocol, DropboxNotifierProtocol {
    
    //MARK: - Dependency injection
    
    /// Logger instance responsible for capturing and logging events or errors.
    private var logger: Log
    
    //MARK: - Types
    
    /// Errors specific to `DropboxNotifier`.
    enum DropboxNotifierError: Error {
        case emptyData
    }
    
    //MARK: - Variables
    
    /// A client to interact with the Dropbox API.
    lazy var client = DropboxClientsManager.authorizedClient
    
    //MARK: - Initializer
    
    /// Initializes a new instance of the `DropboxNotifier`.
    ///
    /// - Parameter logger: An optional logger instance for capturing and logging events.
    init(logger: Log = .init(category: .dropboxNotifier)) {
        self.logger = logger
    }
    
    //MARK: - Public methods
    
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
    ///
    /// - Returns: A boolean value indicating whether the image was successfully sent.
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = true
        
        guard let filePath = thiefDto.filePath else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            return false
        }
        
        var image = NSImage(contentsOf: filePath)
        let info = thiefDto.description()
        if !info.isEmpty {
            image = image?.imageWithText(text: info)
        }
        
        do {
            guard let data = image?.jpegData, !data.isEmpty else {
                throw DropboxNotifierError.emptyData
            }
            
            logger.debug("send: \(thiefDto)")
            
            // Upload the image data to Dropbox.
            let _ = client?.files.upload(path: "/\(filePath.path.split(separator: "/").last ?? "image.jpeg")", input: data)
                .response { [weak self] response, error in
                    if let response {
                        self?.logger.debug("\(response)")
                    } else if let error {
                        self?.logger.error("\(error)")
                    }
                }
                .progress { [weak self] progressData in
                    self?.logger.debug("progress: \(progressData)")
                }
        } catch {
            result = false
            logger.error("\(error.localizedDescription)")
        }
        
        return result
    }
    
    /// Initiates the Dropbox authentication flow.
    ///
    /// - Parameter controller: The view controller from which the authentication flow is started.
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
    /// - Parameters:
    ///   - url: The URL returned after completing the authentication flow.
    ///   - handler: The callback that handles the result of the authentication.
    func completeDropboxAuthWith(url: URL, completionHandler handler: @escaping Commons.StringClosure) {
        // this brings your application back the foreground on redirect
        NSApp.activate(ignoringOtherApps: true)
        
        // Handle the authentication result from Dropbox.
        DropboxClientsManager.handleRedirectURL(url) { [weak self] authResult in
            switch authResult {
            case .success:
                let currentAccount = self?.client?.users.getCurrentAccount()
                currentAccount?.response(completionHandler: { user, error in
                    if let displayName = user?.name.displayName {
                        handler(displayName)
                    }
                })
            case .cancel, .error:
                handler("")
            case .none:
                break
            }
        }
    }
}
