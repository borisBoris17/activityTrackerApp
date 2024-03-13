//
//  PersonDetailView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 16/02/2024.
//

import SwiftUI
import PhotosUI

struct PersonDetailView: View {
    @Environment(\.managedObjectContext) var moc
    
    var person: Person
    var geometry: GeometryProxy
    @Binding var imageHasChanged: Bool
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(person.wrappedName)
                        .font(.largeTitle)
                    Spacer()
                    if viewModel.mode == "view" {
                        Button("Edit") {
                            viewModel.updatedName = person.wrappedName
                            viewModel.mode = "edit"
                        }
                    } else {
                        Button("Save") {
                            imageHasChanged.toggle()
                            viewModel.update(person)
                            
                            try? moc.save()
                        }
                    }
                }
                .padding(.horizontal)
                
                List {
                    Section("Image") {
                        HStack(alignment: .top) {
                            if let selectedImage = viewModel.personImage {
                                Spacer()
                                NavigationLink {
                                    VStack {
                                        selectedImage
                                            .resizable()
                                            .scaledToFit()
                                    }
                                } label: {
                                    ZStack {
                                        selectedImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.4)
                                            .overlay(alignment: .bottomLeading) {
                                                if viewModel.mode == "edit" {
                                                    Button() {
                                                        viewModel.removeImage(on: person)
                                                    } label: {
                                                        Image(systemName: "trash.circle.fill")
                                                            .symbolRenderingMode(.multicolor)
                                                            .font(.system(size: 30))
                                                            .foregroundColor(.red)
                                                    }
                                                    .buttonStyle(.borderless)
                                                }
                                                
                                            }
                                            .overlay(alignment: .bottomTrailing) {
                                                PhotosPicker(selection: $viewModel.personPhotoItem,
                                                             matching: .images,
                                                             photoLibrary: .shared()) {
                                                    if viewModel.mode == "edit" {
                                                        Image(systemName: "pencil.circle.fill")
                                                            .symbolRenderingMode(.multicolor)
                                                            .font(.system(size: 30))
                                                            .foregroundColor(.accentColor)
                                                    }
                                                }
                                                             .buttonStyle(.borderless)
                                            }
                                    }
                                }
                            } else {
                                Image(systemName: "person.crop.rectangle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.4)
                                    .overlay(alignment: .bottomTrailing) {
                                        PhotosPicker(selection: $viewModel.personPhotoItem,
                                                     matching: .images,
                                                     photoLibrary: .shared()) {
                                            if viewModel.mode == "edit" {
                                                Image(systemName: "pencil.circle.fill")
                                                    .symbolRenderingMode(.multicolor)
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.accentColor)
                                            }
                                        }
                                                     .buttonStyle(.borderless)
                                    }
                                    .padding(.leading)
                            }
                        }
                    }
                    .onChange(of: viewModel.personPhotoItem) {
                        Task {
                            if let loaded = try? await viewModel.personPhotoItem?.loadTransferable(type: Data.self) {
                                viewModel.personImageData = loaded
                            } else {
                                print("Failed")
                            }
                        }
                        
                    }
                    .onChange(of: viewModel.personImageData) {
                        if let changedPersonImageData = viewModel.personImageData,
                           let uiImage = UIImage(data: changedPersonImageData) {
                            viewModel.personImage = Image(uiImage: uiImage)
                        }
                    }
                    
                    Section() {
                        HStack(alignment: .top) {
                            Text("Name")
                            Spacer()
                            if viewModel.mode == "view" {
                                Text(person.wrappedName)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                            } else {
                                TextField("Name", text: $viewModel.updatedName)
                                    .multilineTextAlignment(.trailing)
                                    .background(Color.secondary)
                            }
                        }
                    }
                    
                    Section(header: Text("Goals")) {
                        ForEach(person.goalsArray) { goal in
                            NavigationLink {
                                GoalDetailView(goal: goal)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("\(goal.wrappedName)")
                                    Text(goal.wrappedDesc)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }
                        
                        if viewModel.mode == "edit" {
                            HStack {
                                Button("Add Goal") {
                                    viewModel.showAddGoalSheet = true
                                }
                            }
                            .padding(.trailing)
                        }
                        
                    }
                }
            }
            .onChange(of: person) {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                viewModel.personImage = Utils.loadImage(from: imagePath)
            }
            .sheet(isPresented: $viewModel.showAddGoalSheet) {
                AddGoalToPersonView(person: person)
            }
        }
        .onAppear {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            viewModel.personImage = Utils.loadImage(from: imagePath)
        }
    }
    
}

//#Preview {
//    PersonDetailView()
//}
