//
//  DropboxNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2021.
//

import AppKit
import CoreLocation
import SwiftyDropbox

class DropboxNotifier: NotifierProtocol {
    
    //MARK: - Dependency injection
    
    private var logger: Log
    
    //MARK: - Types
    
    enum DropboxNotifierError: Error {
        case emptyData
    }
    
    typealias DropboxNotifierAuthCallback = (() -> Void)
    
    //MARK: - Variables
    
    private var settings: (any AppSettingsProtocol)!
    
    lazy var client = DropboxClientsManager.authorizedClient
    
    //MARK: - initialiser
    
    init(logger: Log = .init(category: .dropboxNotifier)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func register(with settings: any AppSettingsProtocol) {
        self.settings = settings
        
        DropboxClientsManager.setupWithAppKeyDesktop(Secrets.dropboxKey)
        
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(handleGetURLEvent),
                                                     forEventClass: AEEventClass(kInternetEventClass),
                                                     andEventID: AEEventID(kAEGetURL))
    }
    
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
        if info.isEmpty == false {
            image = image?.imageWithText(text: info)
        }
        
        do {
            guard let data = image?.jpegData, data.isEmpty == false else {
                throw DropboxNotifierError.emptyData
            }
            
            logger.debug("send: \(thiefDto)")
            
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
    
    static func authorize(on controller: NSViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(sharedApplication: NSApplication.shared,
                                                        controller: controller,
                                                        loadingStatusDelegate: nil,
                                                        openURL: {(url: URL) -> Void in NSWorkspace.shared.open(url)},
                                                        scopeRequest: scopeRequest)
    }
    
    static func logout() {
        DropboxClientsManager.unlinkClients()
    }
    
    //MARK: - private
    
    @objc private func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        guard let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)), let urlStr = aeEventDescriptor.stringValue else {
            return
        }
        
        processUrl(string: urlStr)
    }
    
    private func processUrl(string: String) {
        guard let url = URL(string: string) else {
            let msg = "unable to construct url: \(string)"
            logger.error(msg)
            return
        }
        
        // this brings your application back the foreground on redirect
        NSApp.activate(ignoringOtherApps: true)
        
        DropboxClientsManager.handleRedirectURL(url) { [weak self] authResult in
            switch authResult {
            case .success:
                let currentAccount = self?.client?.users.getCurrentAccount()
                currentAccount?.response(completionHandler: { user, error in
                    if let displayName = user?.name.displayName {
                        self?.settings?.sync.dropboxName = displayName
                    }
                })
            case .cancel, .error:
                self?.settings?.sync.dropboxName = ""
            case .none:
                break
            }
        }
    }
}
