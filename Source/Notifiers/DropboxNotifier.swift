//
//  DropboxNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2021.
//

import AppKit
import CoreLocation
import SwiftyDropbox

class DropboxNotifier {
    
    enum DropboxNotifierError: Error {
        case emptyData
    }
    
    typealias DropboxNotifierAuthCallback = (() -> Void)
    
    private weak var settings: (any AppSettingsProtocol)?
    
    lazy var client = DropboxClientsManager.authorizedClient
    
    func register(with settings: (any AppSettingsProtocol)?) {
        self.settings = settings
        
        DropboxClientsManager.setupWithAppKeyDesktop("wg60852o20nf6eh")
        
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(handleGetURLEvent),
                                                     forEventClass: AEEventClass(kInternetEventClass),
                                                     andEventID: AEEventID(kAEGetURL))
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = true
        
        guard let filepath = thiefDto.filepath else {
            assert(false, "wrong file path")
            return false
        }
        
        var image = NSImage(contentsOf: filepath)
        let info = thiefDto.info()
        if info.isEmpty == false {
            image = image?.imageWithText(text: info)
        }
        
        do {
            guard let data = image?.jpegData(), data.isEmpty == false else {
                throw DropboxNotifierError.emptyData
            }
            
            let _ = client?.files.upload(path: "/\(filepath.path.split(separator: "/").last ?? "image.jpeg")", input: data)
                .response { response, error in
                    if let response = response {
                        print(response)
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print(progressData)
                }
        } catch {
            result = false
            print(error)
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
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                // this brings your application back the foreground on redirect
                NSApp.activate(ignoringOtherApps: true)
                let url = URL(string: urlStr)!
                let oauthCompletion: DropboxOAuthCompletion = { [weak self] in
                    if let authResult = $0 {
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
                        }
                    }
                }
                DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
            }
        }
    }
}
