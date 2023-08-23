//
//  LastThiefDetectionView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI View that displays the last detected thief's image and a list of related images.
struct LastThiefDetectionView: View {
    @StateObject private var viewModel: LastThiefDetectionViewModel
    
    /// Initializes the view with a given view model.
    ///
    /// - Parameter viewModel: The view model to associate with this view.
    init(viewModel: LastThiefDetectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
#if DEBUG
        // Prints changes for debug purposes.
        let _ = Self._printChanges()
#endif
        VStack(alignment: .center, spacing: ViewConstants.spacing) {
            // If there's a selected item and we can create an image from its data.
            if let lastImage = viewModel.selectedItem, let image = NSImage(data: lastImage.data) {
                // Display the text "LastSnapshot" on top.
                Text("LastSnapshot")
                
                // Display the last captured image.
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(6)
                    .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 240, alignment: .center)
                // When tapped, open the file associated with the last image.
                    .onTapGesture {
                        guard let filePath = lastImage.path else {
                            return
                        }
                        NSWorkspace.shared.open(filePath)
                    }
                
                // Display the date of the last captured image.
                Text("\(lastImage.date, formatter: Date.defaultFormat)")
                
                // If there are more than one images.
                if viewModel.latestImages.count > 1 {
                    // Display them in a horizontal scroll view.
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            // Display each image from the list of latest images.
                            ForEach (viewModel.latestImages) { imageDto in
                                if let image = NSImage(data: imageDto.data) {
                                    ZStack (alignment: .topTrailing) {
                                        ZStack (alignment: .bottom) {
                                            Image(nsImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                                .cornerRadius(4)
                                            
                                            // Display the date for each image in the horizontal scroll view.
                                            Text("\(imageDto.date, formatter: Date.defaultFormat)")
                                                .font(.callout)
                                                .padding(4)
                                                .background(lastImage == imageDto ? Color.accentColor : Color.gray)
                                                .cornerRadius(4)
                                        }
                                        
                                        // A button to remove the image.
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
                                    // When an image in the horizontal scroll view is tapped, set it as the selected item.
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
                // If there's no selected item or image data, display a message indicating that there's nothing to show.
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
