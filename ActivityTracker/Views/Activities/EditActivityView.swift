//
//  EditActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 18/03/2024.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct EditActivityView: View {
    var activity: Activity
    var geometry: GeometryProxy
    
    @Binding var newActivityName: String
    @Binding var newActivityDesc: String
    @Binding var newActivityGoals: Set<Goal>
    @Binding var newActivityPhotoItem: PhotosPickerItem?
    @Binding var newActivityImageData: Data?
    @Binding var newActivityImage: Image?
    @Binding var newActivityMinutes: Int
    @Binding var newActivityHours: Int
    @Binding var newActivityStartDate: Date
    var deleteActivity: (_ activity: Activity) -> Void
    var saveActivity: () -> Void
    
    @State private var showEditGoals = false
    @State private var showDeleteAlert = false
    @State private var isSaving = false
    
    @State private var goalsBlankOnSave = false
    @State private var nameBlankOnSave = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var showRemoveCaputedImageAlert = false
    @State private var showRemoveSelectedImageAlert = false
    
    func validateSave() -> Bool {
        var valid = true
        if newActivityGoals.isEmpty {
            goalsBlankOnSave = true
            valid = false
        } else {
            goalsBlankOnSave = false
        }
        if newActivityName.isEmpty {
            nameBlankOnSave = true
            valid = false
        } else {
            nameBlankOnSave = false
        }
        return valid
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        TextField("Name", text: $newActivityName)
                    } header: {
                        Text("Activity Name")
                    } footer: {
                        if nameBlankOnSave {
                            Text("Name is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(nameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section {
                        TextEditor( text: $newActivityDesc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                    } header: {
                        Text("Description")
                    }
                    
                    Section("Image") {
                        HStack {
                            ImagePickerView(photoItem: $newActivityPhotoItem, selectedImageData: $newActivityImageData, imageSize: geometry.size.width * 0.15)
                                .onChange(of: newActivityImageData) {
                                    if let activityImageData = newActivityImageData,
                                       let uiImage = UIImage(data: activityImageData) {
                                        newActivityImage = Image(uiImage: uiImage)
                                    }
                                }
                            
                            if newActivityPhotoItem == nil {
                                Spacer()
                                newActivityImage?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            }
                        }
                        
                        HStack {
                            Button("Capture Image") {
                                isShowingImagePicker = true
                            }
                            .sheet(isPresented: $isShowingImagePicker) {
                                ImagePicker(selectedImage: $capturedImage)
                            }
                            .onChange(of: capturedImage) {
                                guard let capturedImage else { return }
                                newActivityImage = Image(uiImage: capturedImage)
                            }
                            
                            Spacer()
                            
                            if isShowingImagePicker {
                                Spacer()
                                
                                ProgressView()
                            }
                        }
                    }
                    
                    Section {
                        if showEditGoals {
                            Button("Close Goals") {
                                showEditGoals.toggle()
                            }
                            GoalSelectionView(selectedGoals: $newActivityGoals)
                        } else {
                            Button("Edit Goals") {
                                showEditGoals.toggle()
                            }
                        }
                    } header: {
                        Text("Goals")
                    } footer: {
                        if goalsBlankOnSave {
                            Text("Must select at least one Goal.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(goalsBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section("Date") {
                        DatePicker(
                            "Date of Activity",
                            selection: $newActivityStartDate,
                            in: ...Date.now,
                            displayedComponents: [.date]
                        )
                    }
                    
                    Section("Duration") {
                        DurationPickerView(hours: $newActivityHours, minutes: $newActivityMinutes)
                    }
                    
                    Section {
                        Button("Delete", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Activity?"),
                                message: Text("This is a permanent action."),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteActivity(activity)
                                    dismiss()
                                },
                                secondaryButton: .cancel())
                        }
                    }
                }
                .navigationTitle("Edit Activity")
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
                saveActivity()
            }
        }
    }
}

//#Preview {
//    EditActivityView()
//}
