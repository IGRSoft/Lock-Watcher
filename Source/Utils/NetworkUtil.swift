//
//  NetworkUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation
import os
import SimpleTracer

protocol NetworkUtilProtocol {
    func getIFAddresses() -> String
    
    func getTraceRoute(host: String, complete: @escaping (String) -> ())
}

class NetworkUtil: NetworkUtilProtocol {
    
    //MARK: - Dependency injection
        
    private var logger: Log
    
    //MARK: - Variables
    
    private var simpleTracer: SimpleTracer?
    
    //MARK: - initialiser
    
    init(logger: Log = .init(category: .networkUtil)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    /// Fetch current ip address from ipify.org
    /// - Returns: ip address or empty string
    ///
    func getIFAddresses() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://api.ipify.org")!, encoding: .utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            logger.error("Network Error: \(error.localizedDescription)")
        }
        
        return publicIP
    }
    
    /// Get trace route to your site
    /// - Parameters:
    ///   - host: ip or domain adress
    ///   - complete: list of trace
    ///
    func getTraceRoute(host: String, complete: @escaping (String) -> ()) {
        var traceRoute = ""
        
        simpleTracer = SimpleTracer.trace(host: host, maxTraceTTL: 16) { result in
            switch result {
            case .finished(_, let ip, _):
                traceRoute += "\(ip)}"
                complete(traceRoute)
            case .failed(let error):
                traceRoute += "\(error)}"
                complete(traceRoute)
            case .start(_, let ip, _):
                traceRoute += "Trace route: { \(ip)\n"
            case .router(_, let ip, _):
                traceRoute += "- \(ip)\n"
            case .routerDoesNotRespond:
                traceRoute += "- * * *\n"
            }
        }
    }
}
