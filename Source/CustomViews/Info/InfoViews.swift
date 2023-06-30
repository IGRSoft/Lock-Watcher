//
//  InfoViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI
import LocalAuthentication
import Combine

struct InfoView: View {
    var thiefManager: any ThiefManagerProtocol
    
    @Binding var isInfoHidden: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            ExtendedDivider(isExtended: $isInfoHidden, font: .title)
            if !isInfoHidden {
                if AppSettings.isDebug {
                    Button("Debug") {
                        thiefManager.detectedTrigger({ _ in })
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
    @StateObject private var viewModel: LastThiefDetectionViewModel
    
    init(viewModel: LastThiefDetectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            
            if let lastImage = viewModel.selectedItem,
               let image = NSImage(data: lastImage.data) {
                Text("LastSnapshot")
                
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit().frame(height: 240, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if let filepath = lastImage.path {
                            NSWorkspace.shared.open(filepath)
                        }
                    }
                    .cornerRadius(4)
                
                Text("\(lastImage.date, formatter: Date.dateFormat)")
                
                if viewModel.latestImages.count > 1 {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach (viewModel.latestImages) { imageDto in
                                if let image = NSImage(data: imageDto.data) {
                                    ZStack (alignment: .topTrailing) {
                                        ZStack (alignment: .bottom) {
                                            Image(nsImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                                .cornerRadius(3)
                                            
                                            Text("\(imageDto.date, formatter: Date.dateFormat)")
                                                .padding(2)
                                                .background(lastImage == imageDto ? Color.accentColor : Color.gray)
                                                .cornerRadius(3)
                                        }
                                        
                                        Button(action: {
                                            viewModel.remove(imageDto)
                                        }) {
                                            Image(systemName: "xmark.square.fill")
                                                .font(.body)
                                                .padding(4)
                                                .foregroundColor(.red)
                                                .cornerRadius(3)
                                                
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding()
                                    .onTapGesture {
                                        viewModel.selectedItem = imageDto
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 128, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8.0).stroke(Color.gray, lineWidth: 1)
                    )
                }
            } else {
                Text("Nothing to show")
                    .font(.title2)
            }
        }
    }
    
    func authenticate(action: @escaping () -> Void) {
        
        Timer.scheduledTimer(withTimeInterval: 900.0, repeats: false) { (Timer) in
            viewModel.isUnlocked = false
        }
        
        if viewModel.isUnlocked == false {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, localizedReason: NSLocalizedString("AuthInfo", comment: "")) { success, authenticationError in
                    viewModel.isUnlocked = success
                    if viewModel.isUnlocked {
                        action()
                    }
                }
            } else {
                viewModel.isUnlocked = true
                action()
            }
        } else {
            action()
        }
    }
}
