//
//  XPCAuthentication.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.03.2021.
//

import Foundation
import os

public final class XPCAuthentication: NSObject, XPCAuthenticationProtocol {
    private var outputPipe = Pipe()
    private var buildTask = Process()
    
    /// detected Authentication messages in system log
    /// - Parameters:
    ///   - date: from date
    ///   - replyBlock: callback on record detection
    ///
    public func detectedAuthenticationFailedFromDate(_ date: Date, _ replyBlock: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        // create command line process
        self.buildTask.launchPath = "/usr/bin/log"
        self.buildTask.arguments = ["show",
                                    "--predicate", "(eventMessage CONTAINS \"console domain: invalid credentials\") and (subsystem == \"com.apple.opendirectoryd\")",
                                    "--style", "syslog",
                                    "--start", "\(dateFormatter.string(from: date))"]
        
        os_log(.debug, "XPCAuthentication start listen from \(dateFormatter.string(from: date))")
        
        // add output to process
        self.buildTask.standardOutput = outputPipe
        
        // setup file handle for reading buffer
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        // subscribe to new data notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
                                               object: outputPipe.fileHandleForReading,
                                               queue: nil) { [weak self] notification in
            
            if let output = self?.outputPipe.fileHandleForReading.availableData {
                // check value for new data from log
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                let lines = outputString.split(separator: "\n")
                let detectedAuthenticationFailed = lines.count > 1
                
                os_log(.debug, "XPCAuthentication lines \(lines)")
                
                replyBlock(detectedAuthenticationFailed)
            }
        }
        
        self.buildTask.launch()
        self.buildTask.waitUntilExit()
    }
}
