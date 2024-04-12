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
    var saveActivity: ( _ activityImage: Image?) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var activityPhotoItem: PhotosPickerItem?
    @State private var activityImageData: Data?
    @State private var activityImage: Image?
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    Section("Activity Name") {
                        TextField("Name", text: $name)
                    }
                    
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
                    }
                }
            }
            .navigationTitle("Save Activity")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        saveActivity(activityImage)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .padding()
                }
            }.onAppear {
                timer.upstream.connect().cancel()
            }
        }
    }
}

//#Preview {
//    SaveActivityView()
//}
