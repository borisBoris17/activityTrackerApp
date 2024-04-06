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
    @Binding var path: NavigationPath
    var clearPerson: () -> Void
    
    @FetchRequest var activities: FetchedResults<Activity>
    
    init(person: Person, geometry: GeometryProxy, imageHasChanged: Binding<Bool>, path: Binding<NavigationPath>, clearPerson: @escaping () -> Void) {
        self.person = person
        self.geometry = geometry
        self._imageHasChanged = imageHasChanged
        self._path = path
        self.clearPerson = clearPerson
        
        _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false), NSSortDescriptor(keyPath: \Activity.duration, ascending: false)], predicate: NSPredicate(format: "ANY goals IN %@", person.goalsArray));
    }
    
    @State private var viewModel = ViewModel()
    @State private var temp = NavigationPath()
    
    func deletePerson(person: Person) {
        clearPerson()
        for goal in person.goalsArray {
            for activity in goal.activityArray {
                if activity.goalArray.count == 1 && activity.goalArray.contains(goal) {
                    moc.delete(activity)
                }
            }
            
            moc.delete(goal)
        }
        
        moc.delete(person)
        
        try? moc.save()
    }
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    if viewModel.mode == "view" {
                        Button("Edit") {
                            viewModel.updatedName = person.wrappedName
                            viewModel.showEditPersonSheet.toggle()
                        }
                    } else {
                        Button("Cancel", role: .destructive) {
                            viewModel.mode = "view"
                        }
                        .padding(.trailing)
                        
                        Button("Save") {
                            imageHasChanged.toggle()
                            viewModel.update(person)
                            
                            try? moc.save()
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    HStack(alignment: .top) {
                        if let selectedImage = viewModel.personImage {
                            NavigationLink {
                                VStack {
                                    selectedImage
                                        .resizable()
                                        .scaledToFit()
                                }
                            } label: {
                                ZStack {
                                    if viewModel.isLoading {
                                        LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            .opacity(0.5)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                                    } else {
                                        selectedImage
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .frame(width: geometry.size.width * 0.5)
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
                                                    .padding(10)
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
                                                             .padding(10)
                                            }
                                    }
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.rectangle.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.5)
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
                        
                        Spacer()
                        
                        VStack() {
                            HStack() {
                                if viewModel.mode == "view" {
                                    Text(person.wrappedName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.brandColorDark)
                                } else {
                                    TextField("Name", text: $viewModel.updatedName)
                                        .background(Color.secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.bottom)
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
                    
                    if person.goalsArray.count > 0 || viewModel.mode == "edit" {
                        VStack {
                            HStack {
                                Text("Goals")
                                    .font(.title)
                                    .foregroundStyle(.brandColorDark)
                                
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(person.goalsArray) { goal in
                                        NavigationLink(value: goal) {
                                            GoalCardView(goal: goal, showPerson: false)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    if activities.count > 0 {
                        VStack {
                            HStack {
                                Text("Recent Activities")
                                    .font(.title)
                                    .foregroundStyle(.brandColorDark)
                                
                                Spacer()
                            }
                            
                            ForEach(activities) { activity in
                                NavigationLink(value: activity) {
                                    ActivityCardView(activity: activity, geometry: geometry)
                                        .padding([.trailing, .bottom])
                                }
                            }
                            .id(viewModel.refreshingID)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .padding(.bottom, 50)
            .onChange(of: person) {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                viewModel.personImage = Utils.loadImage(from: imagePath)
                viewModel.mode = "view"
            }
        }
        .onAppear {
            Task {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                viewModel.personImage = Utils.loadImage(from: imagePath)
                viewModel.isLoading = false
            }
        }
        .sheet(isPresented: $viewModel.showEditPersonSheet) {
            EditPersonView(person: person, geometry: geometry, newPersonName: $viewModel.updatedName, newPersonPhotoItem: $viewModel.personPhotoItem, newPersonImageData: $viewModel.personImageData, newPersonImage: $viewModel.personImage, deletePerson: deletePerson) {
                imageHasChanged.toggle()
                viewModel.update(person)
                
                try? moc.save()
            }
        }
    }
}

//#Preview {
//    PersonDetailView()
//}
