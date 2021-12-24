//
//  Preview.swift
//  Preview
//
//  Created by Vitalii Parovishnyk on 03.09.2021.
//

import SwiftUI

struct Preview: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var imagesList: DatabaseDtoList
    @Binding var databaseManager: DatabaseManager
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        
        LazyVStack {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: columns, spacing: 8.0) {
                    ForEach (imagesList.dtos) { imageDto in
                        if let imageData = imageDto.data,
                           let image = NSImage(data: imageData),
                           let imageValue = Image(nsImage: image),
                           let date = imageDto.date  {
                            ZStack (alignment: .topTrailing) {
                                VStack {
                                    imageValue
                                        .resizable()
                                        .scaledToFit().frame(width: 150, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .onTapGesture {
                                            if let filepath = imageDto.path {
                                                NSWorkspace.shared.open(filepath)
                                            }
                                        }
                                    
                                    Text("\(date, formatter: Date.dateFormat)")
                                        .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8.0).stroke(Color.gray, lineWidth: 2)
                                )
                                
                                Button(action: {
                                    databaseManager.remove(imageDto)
                                }) {
                                    Image(systemName: "xmark.square.fill").font(.system(size: 11)).tint(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                            }
                            
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 16.0, trailing: 8.0))
    }
}

/*struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .environmentObject(DatabaseDtoList(dtos: [DatabaseDto]()))
    }
}*/
