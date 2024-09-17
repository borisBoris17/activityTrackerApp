//
//  CaptureImageView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 16/09/2024.
//

import SwiftUI

struct CaptureImageView<Label: View>: View {
    
    @State private var isShowingImagePicker = false
    @Binding var capturedImage: UIImage?
    @Binding var activityImage: Image?
    @Binding var isLoading: Bool
    let label: () -> Label
    
    
    var body: some View {
        HStack {
            Button {
                isShowingImagePicker = true
                isLoading = true
            } label : {
                label()
            }
            .sheet(isPresented: $isShowingImagePicker, onDismiss: { isLoading = false }) {
                ImagePicker(selectedImage: $capturedImage)
            }
            .onChange(of: capturedImage) {
                guard let capturedImage else { return }
                activityImage = Image(uiImage: capturedImage)
            }
        }
    }
}

//#Preview {
//    CaptureImageView()
//}
