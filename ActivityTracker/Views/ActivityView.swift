//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI
import PhotosUI

struct ActivityView: View {
    
    let activity: Activity
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var mode = "view"
    @State var updatedDuration = ""
    @State var updatedName = ""
    @State var updatedDescription = ""
    @State var hours = 0
    @State var minutes = 0
    
    @State private var activityPhotoItem: PhotosPickerItem?
    @State private var activityImageData: Data?
    @State private var activityImage: Image?
    
    @State private var showEditGoals = false
    @State private var updatedGoals = Set<Goal>()
    
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        
        GeometryReader { geometry in
            Form {
                HStack(alignment: .top) {
                    if mode == "view" {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.wrappedName)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextField("Name", text: $updatedName)
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
                
                HStack(alignment: .top) {
                    if mode == "view" {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.wrappedDesc)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextEditor( text: $updatedDescription)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
                
                HStack {
                    if mode == "view" {
                        NavigationLink {
                            VStack {
                                activityImage?
                                    .resizable()
                                    .scaledToFit()
                            }
                        } label: {
                            HStack {
                                activityImage?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            }
                        }
                    } else {
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
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Goals")
                        if mode == "edit" {
                            Button("Edit") {
                                updatedGoals = Set<Goal>(activity.goalArray)
                                showEditGoals.toggle()
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
                    Spacer()
                    VStack(alignment: .trailing) {
                        ForEach(activity.goalArray) { goal in
                            ForEach(goal.peopleArray) { person in
                                Text("\(person.wrappedName) - \(goal.wrappedName)" )
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    
                    if mode == "view" {
                        Text("Duration")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.formattedDuration + " Hours")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Duration")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Picker("Hours", selection: $hours) {
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
                        
                        Picker("Minutes", selection: $minutes) {
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
                
                HStack(alignment: .top) {
                    Text("Date")
                        .frame(width: geometry.size.width * 0.3, alignment: .leading)
                    Spacer()
                    Text(activity.wrappedStartDate.formatted(.dateTime.day().month().year()))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding(.top)
            .navigationBarTitle("Activity Detail", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup {
                    if mode == "view" {
                        Button("Edit") {
                            updatedDuration = activity.formattedDuration
                            updatedName = activity.wrappedName
                            updatedDescription = activity.wrappedDesc
                            let durationSegments = activity.formattedDuration.components(separatedBy: ".")
                            hours = Int(durationSegments[0]) ?? 0
                            let decimalMinutes = Double(durationSegments[1]) ?? 0
                            let calculatedMinutes = Int(ceil((decimalMinutes / 100) * Double(minuteLength)))
                            if calculatedMinutes < hourLength {
                                minutes = calculatedMinutes
                            } else {
                                minutes = 0
                            }
                            
                    
                            mode = "edit"
                            
                        }
                        .padding()
                    } else {
                        Button("Save") {
                            var removedGoals = Set<Goal>()
                            var addedGoals = Set<Goal>()
                            var editedGoal = Set<Goal>()
                            let newSecondsFromHour = hours * minuteLength * hourLength
                            let newSecondsFromMinutes = minutes * hourLength
                            let newSeconds = Double(newSecondsFromHour + newSecondsFromMinutes)
                            
                            // Find the Goals that were removed
                            for existingGoal in activity.goalArray {
                                if !updatedGoals.contains(existingGoal) {
                                    removedGoals.insert(existingGoal)
                                }
                            }
                            
                            // Find all the Goals that were added.
                            for updatedGoal in updatedGoals {
                                if !activity.goalArray.contains(updatedGoal) {
                                    addedGoals.insert(updatedGoal)
                                } else {
                                    editedGoal.insert(updatedGoal)
                                }
                            }
                            
                            // take away the progress that was made toward the removed goals (using the previously saved time)
                            for removedGoal in removedGoals {
                                removedGoal.progress = Double(activity.duration)
                            }
                            
                            // Add the new time to the added goals progress
                            for addedGoal in addedGoals {
                                addedGoal.progress = newSeconds.rounded(.up)
                            }
                            
                            // modify the goals that were neither removed or added
                            for goal in editedGoal {
                                goal.progress = goal.progress - Double(activity.duration) + newSeconds.rounded(.up)
                            }
                            
                            activity.duration = Int16(newSeconds.rounded(.up))
                            activity.name = updatedName
                            activity.desc = updatedDescription
                            let renderer = ImageRenderer(content: activityImage)
                            if let uiImage = renderer.uiImage {
                                if let data = uiImage.pngData() {
                                    let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
                                    try? data.write(to: filename)
                                }
                            }
                            
                            try? moc.save()
                            updatedGoals = Set<Goal>()
                            withAnimation {
                                mode = "view"
                            }
                        }
                        .disabled(updatedDuration.isEmpty)
                        .padding()
                    }
                }
            }
            .onAppear {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
                do {
                    let foundActivityImageData = try Data(contentsOf: imagePath)
                    let uiImage = UIImage(data: foundActivityImageData)
                    activityImage = Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
                } catch {
                    print("Error reading file: \(error)")
                }
            }
            .sheet(isPresented: $showEditGoals) {
                VStack {
                    NavigationView {
                        GoalSelectionView(selectedGoals: $updatedGoals)
                        .navigationTitle("Edit Goals")
                        .toolbar {
                            ToolbarItemGroup {
                                Button("Back") {
                                    showEditGoals.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: Activity)
//    }
//}
