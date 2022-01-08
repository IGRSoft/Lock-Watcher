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
            if isInfoHidden {
                Button(action: {
                    isInfoHidden = false
                }) {
                    Image(systemName: "chevron.compact.down").font(.system(size: 28))
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                Button(action: {
                    isInfoHidden = true
                }) {
                    Image(systemName: "chevron.compact.up").font(.system(size: 28))
                }.buttonStyle(BorderlessButtonStyle())
                
                VStack(alignment: .center) {
#if DEBUG
                    Button("Debug") {
                        thiefManager.detectedTriger()
                    }
#endif
                    
                    Button("Notices") {
                        exit(0)
                    }
                    Button("Quit") {
                        exit(0)
                    }
                    Text("© IGR Software 2008 - 2021")
                }
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
            if let lastImage = latestImages.dtos.last,
               let imageData = lastImage.data,
               let image = NSImage(data: imageData),
               let imageValue = Image(nsImage: image),
               let date = lastImage.date {
                Text("LastSnapshot")
                imageValue
                    .resizable()
                    .scaledToFit().frame(width: 324, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if let filepath = lastImage.path {
                            NSWorkspace.shared.open(filepath)
                        }
                    }
                Text("\(date, formatter: Date.dateFormat)")
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
                
                Divider()
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

            // check whether biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, localizedReason: NSLocalizedString("AuthInfo", comment: "")) { success, authenticationError in
                    isUnlocked = success
                    if success {
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
