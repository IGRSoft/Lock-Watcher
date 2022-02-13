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

class NetworkUtil {
    private var simpleTracer: SimpleTracer?
    
    func getIFAddresses() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://api.ipify.org")!, encoding: String.Encoding.utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            os_log(.error, "Network Error: %@", "\(error)")
        }
        
        return publicIP
    }
    
    func getTraceRoute(host: String, compleate: @escaping (String) -> ()) {
        var traceRoute = ""
        
        simpleTracer = SimpleTracer.trace(host: host, maxTraceTTL: 15) { (result) in
            switch result {
            case .finished(_, let ip, _):
                traceRoute += "\(ip)}"
                compleate(traceRoute)
            case .failed(let error):
                traceRoute += "\(error)}"
                compleate(traceRoute)
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
