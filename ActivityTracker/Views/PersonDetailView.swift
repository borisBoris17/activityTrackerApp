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
    
    @State var mode = "view"
    @State var updatedName = ""
    @State var showAddGoalSheet = false
    
    @State private var personPhotoItem: PhotosPickerItem?
    @State private var personImageData: Data?
    @State private var personImage: Image?
    @State private var isLoading = true
    
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                VStack {
                    HStack {
                        Text(person.wrappedName)
                            .font(.largeTitle)
                        Spacer()
                        if mode == "view" {
                            Button("Edit") {
                                updatedName = person.wrappedName
                                mode = "edit"
                            }
                        } else {
                            Button("Save") {
                                imageHasChanged.toggle()
                                person.name = updatedName
                                
                                let renderer = ImageRenderer(content: personImage)
                                if let uiImage = renderer.uiImage {
                                    if let data = uiImage.jpegData(compressionQuality: 0.2) {
                                        let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                                        try? data.write(to: filename)
                                    }
                                }
                                
                                try? moc.save()
                                mode = "view"
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    List {
                        Section("Image") {
                            HStack(alignment: .top) {
                                if let personImage {
                                    Spacer()
                                    NavigationLink {
                                        VStack {
                                            personImage
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    } label: {
                                        personImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.4)
                                            .overlay(alignment: .bottomTrailing) {
                                                PhotosPicker(selection: $personPhotoItem,
                                                             matching: .images,
                                                             photoLibrary: .shared()) {
                                                    if mode == "edit" {
                                                        Image(systemName: "pencil.circle.fill")
                                                            .symbolRenderingMode(.multicolor)
                                                            .font(.system(size: 30))
                                                            .foregroundColor(.accentColor)
                                                    }
                                                }
                                                             .buttonStyle(.borderless)
                                            }
                                    }
                                } else {
                                    Image(systemName: "person.crop.rectangle.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.4)
                                        .overlay(alignment: .bottomTrailing) {
                                            PhotosPicker(selection: $personPhotoItem,
                                                         matching: .images,
                                                         photoLibrary: .shared()) {
                                                if mode == "edit" {
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
                        .onChange(of: personPhotoItem) { newPhoto in
                            Task {
                                if let loaded = try? await newPhoto?.loadTransferable(type: Data.self) {
                                    personImageData = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                            
                        }
                        .onChange(of: personImageData) { newData in
                            if let newData,
                               let uiImage = UIImage(data: newData) {
                                personImage = Image(uiImage: uiImage)
                            }
                        }
                        
                        Section() {
                            HStack(alignment: .top) {
                                Text("Name")
                                Spacer()
                                if mode == "view" {
                                    Text(person.wrappedName)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.trailing)
                                } else {
                                    TextField("Name", text: $updatedName)
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
                            
                        }
                    }
                    
                    if mode == "edit" {
                        HStack {
                            Spacer()
                            
                            Button("Add Goal") {
                                showAddGoalSheet = true
                            }
                        }
                        .padding(.trailing)
                    }
                }
                .onChange(of: person) { newPerson in
                    let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(newPerson.wrappedId).png")
                    do {
                        let foundActivityImageData = try Data(contentsOf: imagePath)
                        let uiImage = UIImage(data: foundActivityImageData)
                        personImage = Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
                    } catch {
                        personImage = nil
                        print("Error reading file: \(error)")
                    }
                }
                .sheet(isPresented: $showAddGoalSheet) {
                    AddGoalToPersonView(person: person)
                }
            }
        }
        .onAppear {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            do {
                let foundActivityImageData = try Data(contentsOf: imagePath)
                let uiImage = UIImage(data: foundActivityImageData)
                personImage = Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
            } catch {
                print("Error reading file: \(error)")
            }
            isLoading = false
        }
    }
    
}

//#Preview {
//    PersonDetailView()
//}