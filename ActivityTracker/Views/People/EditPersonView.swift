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
    @State private var isSaving = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var nameBlankOnSave = false
    
    func validateSave() -> Bool {
        var valid = true
        if newPersonName.isEmpty {
            nameBlankOnSave = true
            valid = false
        } else {
            nameBlankOnSave = true
            valid = true
        }
        return valid
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        TextField("Name", text: $newPersonName)
                    } header: {
                        Text("Activity Name")
                        
                    } footer: {
                        if nameBlankOnSave {
                            Text("Name is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(nameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
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
                            if validateSave() {
                                isSaving = true
                            }
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
            
            if isSaving {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(5)
                }
            }
        }
        .onChange(of: isSaving) {
            Task {
                dismiss()
                savePerson()
            }
        }
    }
}

//#Preview {
//    EditPersonView()
//}
