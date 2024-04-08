//
//  PersonDetailView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/03/2024.
//

import Foundation
import _PhotosUI_SwiftUI
import SwiftUI

extension PersonDetailView {
    @Observable
    class ViewModel {
        
        var mode = "view"
        var updatedName = ""
        var showEditPersonSheet = false
        
        var personPhotoItem: PhotosPickerItem?
        var personImageData: Data?
        var personImage: Image?
        
        var isLoading = true
        
        func removeImage(on person: Person) {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            Utils.removeImage(from: imagePath)
            personImage = nil
        }
        
        @MainActor func update(_ person: Person) {
            person.name = updatedName
            
            let renderer = ImageRenderer(content: personImage)
            if let uiImage = renderer.uiImage {
                if let data = uiImage.jpegData(compressionQuality: 0.2) {
                    let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                    try? data.write(to: filename)
                }
                let size = CGSize(width: 300, height: 300)
                if let thumbImage = uiImage.preparingThumbnail(of: size) {
                    if let data = thumbImage.jpegData(compressionQuality: 1.0) {
                        let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId)Thumb.png")
                        try? data.write(to: filename)
                    }
                }
            }
            
            mode = "view"
        }
    }
}
