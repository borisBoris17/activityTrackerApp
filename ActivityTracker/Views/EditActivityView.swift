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
    var saveActivity: () -> Void
    
    @State private var showEditGoals = false

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                    HStack {
                        Picker("Hours", selection: $newActivityHours) {
                            ForEach(0..<25) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 150)
                        .clipped()
                        
                        VStack {
                            Spacer()
                            Text("Hrs")
                            Spacer()
                        }
                        .frame(maxHeight: 150)
                        .clipped()
                        
                        Picker("Minutes", selection: $newActivityMinutes) {
                            ForEach(0..<60) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 150)
                        .clipped()
                        
                        VStack {
                            Spacer()
                            Text("Min")
                            Spacer()
                        }
                        .frame(maxHeight: 150)
                        .clipped()
                    }
                }
            }
            .navigationTitle("Edit Activity")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        saveActivity()
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
    }
}

//#Preview {
//    EditActivityView()
//}
