//
//  AddPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddPersonView: View {
    @State private var newName = ""
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var personPhotoItem: PhotosPickerItem?
    @State private var personImageData: Data?
    @State private var personImage: Image?
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationStack {
                    Form {
                        Section {
                            TextField("Name", text: $newName)
                            if #available(iOS 17.0, *) {
                                ImagePickerView(photoItem: $personPhotoItem, selectedImageData: $personImageData, imageSize: geometry.size.width * 0.15)
                                    .onChange(of: personImageData) {
                                        if let personImageData,
                                           let uiImage = UIImage(data: personImageData) {
                                            personImage = Image(uiImage: uiImage)
                                        }
                                    }
                            }
                        }
                    }
                    .navigationBarTitle("Add Person", displayMode: .inline)
                    .toolbar {
                        ToolbarItem {
                            Button("Save") {
                                let newPerson = Person(context: moc)
                                newPerson.id = UUID()
                                newPerson.name = newName
                                
                                if personImage != nil {
                                    print("has personImage")
                                    let renderer = ImageRenderer(content: personImage)
                                    if let uiImage = renderer.uiImage {
                                        print("has uiImage")
                                        if let data = uiImage.pngData() {
                                            let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(newPerson.id!).png")
                                            print("\(filename)")
                                            do {
                                                try data.write(to: filename)
                                            } catch {
                                                print("Error writting file: \(error)")
                                            }
                                        }
                                    }
                                }
                                
                                try? moc.save()
                                dismiss()
                            }
                            .disabled(newName.isEmpty)
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
