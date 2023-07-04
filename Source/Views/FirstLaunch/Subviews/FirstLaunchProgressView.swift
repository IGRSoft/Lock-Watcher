//
//  FirstLaunchProgressView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchProgressView: View {
    private var viewModel: FirstLaunchProgressViewModel
    
    init(viewModel: FirstLaunchProgressViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Label("", systemImage: viewModel.position.rawValue)
            .onAppear(perform: viewModel.startAnimation)
            .font(.system(size: viewModel.frameSize.height * 0.75))
            .frame(width: viewModel.frameSize.width, height: viewModel.frameSize.height, alignment: .center)
    }
}

struct FirstLaunchProgressViews_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchProgressView(viewModel: FirstLaunchProgressViewModel.preview)
    }
}
