//
//  ImagePickerView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/01/2024.
//

import SwiftUI
import PhotosUI

@available(iOS 17.0, *)
struct ImagePickerView: View {
    @Binding var photoItem: PhotosPickerItem?
    @Binding var image: Image?
    
    var imageSize: CGFloat
    
    var body: some View {
        HStack {
            PhotosPicker("Select Image", selection: $photoItem, matching: .images)
            Spacer()
            image?
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
        }
        .onChange(of: photoItem) {
            Task {
                if let loaded = try? await photoItem?.loadTransferable(type: Image.self) {
                    image = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
    
}

//#Preview {
//    ImagePickerView()
//}
