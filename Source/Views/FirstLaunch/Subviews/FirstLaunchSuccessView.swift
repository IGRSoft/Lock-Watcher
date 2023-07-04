//
//  FirstLaunchSuccessView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchSuccessView: View {
    @Binding var successCountDown: Int
    
    @State var frameSize: CGSize
    
    var body: some View {
        VStack {
            Label("SetupSuccess", systemImage: "bolt.circle")
                .font(.system(size: frameSize.height * 0.2))
                .padding(.horizontal)
                .foregroundColor(Color("success"))
            Text("Tips0")
                .font(.headline)
                .foregroundColor(Color("success"))
            Image("tips0").aspectRatio(contentMode: .fit)
                .frame(width: frameSize.width, alignment: .center)
            Text(String(format: NSLocalizedString("SuccessTimer %d", comment: ""), successCountDown))
                .font(.body)
        }
    }
}

struct FirstLaunchSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchSuccessView(successCountDown: .constant(5), frameSize: CGSize(width: 400, height: 300))
    }
}
