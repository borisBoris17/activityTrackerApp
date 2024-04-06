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
    var deleteActivity: (_ activity: Activity) -> Void
    var saveActivity: () -> Void
    
    @State private var showEditGoals = false
    @State private var showDeleteAlert = false
    @State private var isSaving = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section("Activity Name") {
                        TextField("Name", text: $newActivityName)
                    }
                    
                    Section("description") {
                        TextEditor( text: $newActivityDesc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
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
                    }
                    
                    Section("Goals") {
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
                    }
                    
                    Section("Duration") {
                        DurationPickerView(hours: $newActivityHours, minutes: $newActivityMinutes)
                    }
                    
                    Section {
                        Button("Delete") {
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
                            isSaving = true
                        }
                        .padding()
                        .disabled(newActivityName.isEmpty || newActivityDesc.isEmpty || newActivityGoals.isEmpty)
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
