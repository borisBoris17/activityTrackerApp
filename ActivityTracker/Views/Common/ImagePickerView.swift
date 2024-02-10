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
    @Binding var selectedImageData: Data?
    
    var imageSize: CGFloat
    
    var body: some View {
        HStack {
            PhotosPicker("Select Image", selection: $photoItem, matching: .images)
            Spacer()
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
            }
        }
        .onChange(of: photoItem) {
            Task {
                if let loaded = try? await photoItem?.loadTransferable(type: Data.self) {
                    selectedImageData = loaded
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
