//
//  InfoViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI
import LocalAuthentication

struct InfoView: View {
    var thiefManager: ThiefManager
    
    @Binding var isInfoHidden: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            ExtendedDivider(isExtended: $isInfoHidden, font: .title)
            if !isInfoHidden {
                if AppSettings.isDebug {
                    Button("Debug") {
                        thiefManager.detectedTrigger()
                    }
                }
                Button("ButtonSettings") {
                    NSApplication.displaySettingsWindow()
                }
                Button("Quit") {
                    exit(0)
                }
                Link("© IGR Software 2008 - 2023", destination: URL(string: "https://igrsoft.com")!)
            }
        }
    }
}

struct LastThiefDetectionView: View {
    @Binding var databaseManager: DatabaseManager
    @State var isPreviewActive: Bool = false
    @State private var isUnlocked = false
    
    var body: some View {
        let latestImages = databaseManager.latestImages()
        
        VStack(alignment: .center, spacing: 8.0) {
            Divider()
                .background(Color("divider"))
            
            if let lastImage = latestImages.dtos.last,
               let image = NSImage(data: lastImage.data) {
                Text("LastSnapshot")
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit().frame(width: 324, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if let filepath = lastImage.path {
                            NSWorkspace.shared.open(filepath)
                        }
                    }
                Text("\(lastImage.date, formatter: Date.dateFormat)")
                if latestImages.dtos.count > 1 {
                    Button("LastSnapshots") {
                        authenticate {
                            isPreviewActive = true
                        }
                    }
                    .popover(isPresented: $isPreviewActive, arrowEdge: .leading) {
                        Preview(databaseManager: $databaseManager)
                            .frame(width: 168 * 4,
                                   height: 164.0 * ceil(Double(latestImages.dtos.count) / 4.0),
                                   alignment: .top)
                            .environmentObject(latestImages)
                    }
                }
            }
        }
    }
    
    func authenticate(action: @escaping () -> Void) {
        
        Timer.scheduledTimer(withTimeInterval: 900.0, repeats: false) { (Timer) in
            isUnlocked = false
        }
        
        if isUnlocked == false {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, localizedReason: NSLocalizedString("AuthInfo", comment: "")) { success, authenticationError in
                    isUnlocked = success
                    if isUnlocked {
                        action()
                    }
                }
            } else {
                isUnlocked = true
                action()
            }
        } else {
            action()
        }
    }
}
