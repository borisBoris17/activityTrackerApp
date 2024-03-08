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
                    HStack(alignment: .top) {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                    HStack(alignment: .top) {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextEditor( text: $desc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                    HStack(alignment: .top) {
                        if #available(iOS 17.0, *) {
                            ImagePickerView(photoItem: $activityPhotoItem, selectedImageData: $activityImageData, imageSize: geometry.size.width * 0.15)
                                .onChange(of: activityImageData) {
                                    if let activityImageData,
                                       let uiImage = UIImage(data: activityImageData) {
                                        activityImage = Image(uiImage: uiImage)
                                    }
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
