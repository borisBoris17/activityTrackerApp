//
//  EditPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 18/03/2024.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct EditPersonView: View {
    var person: Person
    var geometry: GeometryProxy
    @Binding var newPersonName: String
    @Binding var newPersonPhotoItem: PhotosPickerItem?
    @Binding var newPersonImageData: Data?
    @Binding var newPersonImage: Image?
    var deletePerson: (_ person: Person) -> Void
    var savePerson: () -> Void
    
    @State private var showAddGoalSheet = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Name") {
                    TextField("Name", text: $newPersonName)
                }
                
                Section("Image") {
                    HStack {
                        ImagePickerView(photoItem: $newPersonPhotoItem, selectedImageData: $newPersonImageData, imageSize: geometry.size.width * 0.15)
                            .onChange(of: newPersonImageData) {
                                if let personImageData = newPersonImageData,
                                   let uiImage = UIImage(data: personImageData) {
                                    newPersonImage = Image(uiImage: uiImage)
                                }
                            }
                        
                        if newPersonPhotoItem == nil {
                            Spacer()
                            newPersonImage?
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                        }
                    }
                }
                
                Button("Add Goal") {
                    showAddGoalSheet.toggle()
                }
                
                Section {
                    Button("Delete") {
                        showDeleteAlert = true
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Delete \(person.wrappedName)?"),
                            message: Text("This is a permanent action."),
                            primaryButton: .destructive(Text("Delete")) {
                                deletePerson(person)
                                dismiss()
                            },
                            secondaryButton: .cancel())
                    }
                }
            }
            .navigationTitle("Edit Person")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        savePerson()
                        dismiss()
                    }
                    .padding()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGoalSheet) {
            AddGoalToPersonView(person: person)
        }
    }
}

//#Preview {
//    EditPersonView()
//}
