//
//  SaveActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 23/01/2024.
//

import SwiftUI
import Combine
import PhotosUI

struct SaveActivityView: View {
    @Binding var name: String
    @Binding var desc: String
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var activityImage: Image?
    var saveActivity: ( _ activityImage: Image?) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var activityPhotoItem: PhotosPickerItem?
    @State private var activityImageData: Data?
    
    @State private var nameBlankOnSave = false
    
    @State private var capturedImage: UIImage?
    @State private var isLoadingCaptureImage = false
    
    func validateSave() -> Bool {
        var valid = true
        if name.isEmpty {
            nameBlankOnSave = true
            valid = false
        } else {
            nameBlankOnSave = false
        }
        return valid
    }
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    Section {
                        TextField("Name", text: $name)
                    } header: {
                        Text("Activity Name")
                    } footer: {
                        if nameBlankOnSave {
                            Text("Name is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(nameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section("description") {
                        TextEditor( text: $desc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                    }
                    
                    Section("Image") {
                        HStack {
                            ImagePickerView(photoItem: $activityPhotoItem, selectedImageData: $activityImageData, imageSize: geometry.size.width * 0.15)
                                .onChange(of: activityImageData) {
                                    if let activityImageData = activityImageData,
                                       let uiImage = UIImage(data: activityImageData) {
                                        activityImage = Image(uiImage: uiImage)
                                    }
                                }
                            
                            if activityPhotoItem == nil {
                                Spacer()
                                activityImage?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            }
                        }
                        
                        HStack {
                            CaptureImageView(capturedImage: $capturedImage, activityImage: $activityImage, isLoading: $isLoadingCaptureImage) {
                                Text("Capture Image")
                            }
                            
                            Spacer()
                            
                            if isLoadingCaptureImage {
                                Spacer()
                                
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Save Activity")
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button("Dismiss") {
                            dismiss()
                        }
                        Button("Save") {
                            if validateSave() {
                                saveActivity(activityImage)
                                dismiss()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

//#Preview {
//    SaveActivityView()
//}
