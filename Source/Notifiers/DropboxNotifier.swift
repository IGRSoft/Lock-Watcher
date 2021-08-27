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
    
    private var settings: SettingsDto?
    
    lazy var client = DropboxClientsManager.authorizedClient
    
    func register(settings: SettingsDto?) {
        self.settings = settings
        
        DropboxClientsManager.setupWithAppKeyDesktop("wg60852o20nf6eh")
        
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(handleGetURLEvent(_:replyEvent:)),
                                                     forEventClass: AEEventClass(kInternetEventClass),
                                                     andEventID: AEEventID(kAEGetURL))
    }
    
    func send(photo path: String, coordinate: CLLocationCoordinate2D) -> Bool {
        var result = true
        
        var image = NSImage(contentsOf: URL(fileURLWithPath: path))
        image = image?.imageWithText(text: String(describing: coordinate))
        
        do {
            guard let data = image?.tiffRepresentation else {
                throw DropboxNotifierError.emptyData
            }
            
            let _ = client?.files.upload(path: "/\(path.split(separator: "/").last ?? "image.png")", input: data)
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
        DropboxClientsManager.authorizeFromControllerV2(sharedWorkspace: NSWorkspace.shared,
                                                        controller: controller,
                                                        loadingStatusDelegate: nil,
                                                        openURL: {(url: URL) -> Void in NSWorkspace.shared.open(url)},
                                                        scopeRequest: scopeRequest
        )
    }
    
    static func logout() {
        DropboxClientsManager.unlinkClients()
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = URL(string: urlStr)!
                let oauthCompletion: DropboxOAuthCompletion = { [weak self] in
                    if let authResult = $0 {
                        switch authResult {
                        case .success:
                            let currentAccount = self?.client?.users.getCurrentAccount()
                            currentAccount?.response(completionHandler: { user, error in
                                if let displayName = user?.name.displayName {
                                    self?.settings?.dropboxName = displayName
                                    self?.settings?.save()
                                }
                            })
                        case .cancel, .error:
                            self?.settings?.dropboxName = ""
                            self?.settings?.save()
                        }
                    }
                }
                DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
                // this brings your application back the foreground on redirect
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
