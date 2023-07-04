//
//  InfoViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI
import Combine

struct InfoView: View {
    @ObservedObject private var viewModel: InfoViewModel
    
    init(viewModel: InfoViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        let _ = Self._printChanges()
        
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                if AppSettings.isImageCaptureDebug {
                    Button(action: viewModel.debugTrigger, label: viewModel.debugTitle)
                }
                Button(action: viewModel.openSettings, label: viewModel.openSettingsTitle)
                
                Button(action: viewModel.quitApp, label: viewModel.quitAppTitle)
                
                Link(viewModel.linkText, destination: viewModel.linkUrl)
                    .frame(maxWidth: .infinity)
            }
            .extended($viewModel.isInfoExtended, font: .title)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(viewModel: InfoViewModel(thiefManager: ThiefManagerPreview(), isInfoExtended: .constant(false)))
        
        InfoView(viewModel: InfoViewModel(thiefManager: ThiefManagerPreview(), isInfoExtended: .constant(true)))
    }
}
