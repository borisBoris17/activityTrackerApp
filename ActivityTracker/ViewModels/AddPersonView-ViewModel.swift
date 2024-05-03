//
//  AddPersonView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/03/2024.
//

import SwiftUI
import _PhotosUI_SwiftUI


extension AddPersonView {
    @Observable
    class ViewModel {
        
        var newName = ""
        var personPhotoItem: PhotosPickerItem?
        var personImageData: Data?
        var personImage: Image?
        var nameBlankOnSave = false
        
        func validateSave() -> Bool {
            var valid = true
            if newName.isEmpty {
                nameBlankOnSave = true
                valid = false
            } else {
                nameBlankOnSave = true
                valid = true
            }
            return valid
        }
        
        func updatePersonImage() {
            if let selectedImageData = personImageData,
               let uiImage = UIImage(data: selectedImageData) {
                personImage = Image(uiImage: uiImage)
            }
        }
        
        @MainActor func savePerson(newPerson: Person) {
            
            newPerson.id = UUID()
            newPerson.name = newName
            
            if personImage != nil {
                let renderer = ImageRenderer(content: personImage)
                if let uiImage = renderer.uiImage {
                    if let data = uiImage.pngData() {
                        let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(newPerson.id!).png")
                        do {
                            try data.write(to: filename)
                        } catch {
                            print("Error writting file: \(error)")
                        }
                    }
                    let size = CGSize(width: 300, height: 300)
                    if let thumbImage = uiImage.preparingThumbnail(of: size) {
                        if let data = thumbImage.jpegData(compressionQuality: 1.0) {
                            let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(newPerson.id!)Thumb.png")
                            try? data.write(to: filename)
                        }
                    }
                }
            }
            
        }
    }
}
