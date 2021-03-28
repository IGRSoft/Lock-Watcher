//
//  XPCAuthentication.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.03.2021.
//

import Foundation

public final class XPCAuthentication: NSObject, XPCAuthenticationProtocol {
    var outputPipe:Pipe!
    var buildTask:Process!
    
    public func detectedAuthenticationFailedFromDate(_ date: Date, _ replyBlock: @escaping (Bool) -> Void) {
        self.buildTask = Process()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        self.buildTask.launchPath = "/usr/bin/log"
        self.buildTask.arguments = ["show",
                                    "--predicate", "(eventMessage CONTAINS \"Authentication failed\") and (subsystem == \"com.apple.opendirectoryd\")",
                                    "--style", "syslog",
                                    "--start", "\(dateFormatter.string(from: date))"]
        
        outputPipe = Pipe()
        self.buildTask.standardOutput = outputPipe
        
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) { [weak self]
          notification in
          
            if let output = self?.outputPipe.fileHandleForReading.availableData {
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                let lines = outputString.split(separator: "\n")
                let detectedAuthenticationFailed = lines.count > 1
                
                replyBlock(detectedAuthenticationFailed)
            }
        }
        
        self.buildTask.launch()
        self.buildTask.waitUntilExit()
    }
}
