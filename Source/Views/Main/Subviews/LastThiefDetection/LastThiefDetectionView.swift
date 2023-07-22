//
//  LastThiefDetectionView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct LastThiefDetectionView: View {
    @StateObject private var viewModel: LastThiefDetectionViewModel
    
    init(viewModel: LastThiefDetectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack(alignment: .center, spacing: ViewConstants.spacing) {
            
            if let lastImage = viewModel.selectedItem, let image = NSImage(data: lastImage.data) {
                Text("LastSnapshot")
                
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 240, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        guard let filePath = lastImage.path else {
                            return
                        }
                        NSWorkspace.shared.open(filePath)
                    }
                    .cornerRadius(4)
                
                Text("\(lastImage.date, formatter: Date.defaultFormat)")
                
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
                                            
                                            Text("\(imageDto.date, formatter: Date.defaultFormat)")
                                                .font(.callout)
                                                .padding(4)
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
                    .frame(height: 148, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8.0).stroke(Color.gray, lineWidth: 1)
                    )
                }
            } else {
                Text("Nothing to show")
                    .font(.title2)
                    .padding()
            }
        }
    }
}

struct LastThiefDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        LastThiefDetectionView(viewModel: LastThiefDetectionViewModel(databaseManager: DatabaseManagerPreview()))
    }
}
