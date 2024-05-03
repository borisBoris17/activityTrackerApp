//
//  StartActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI
import Combine
import _PhotosUI_SwiftUI

struct StartActivityView: View {
    var geometry: GeometryProxy
    @Binding var name: String
    @Binding var desc: String
    @Binding var goals: [Goal]
    
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var activityStatus: ActivityStatus
    @Binding var startTime: Date
    @Binding var manualDurationHours: Int
    @Binding var manualDurationMinutes: Int
    var saveActivity: ( _ activityImage: Image?, _ isManual: Bool) -> Void
    
    @State private var selectedGoals = Set<Goal>()
    @State private var isManaualAdd = false
    @State private var activityPhotoItem: PhotosPickerItem?
    @State private var activityImageData: Data?
    @State private var activityImage: Image?
    @State private var nameBlankOnSave = false
    @State private var descBlankOnSave = false
    @State private var goalsBlankOnSave = false
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: false), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var allGoals: FetchedResults<Goal>
    
    @Environment(\.dismiss) var dismiss
    
    func validateSave() -> Bool {
        var valid = true
        if selectedGoals.count < 1 {
            goalsBlankOnSave = true
            valid = false
        } else {
            goalsBlankOnSave = false
        }
        if name.isEmpty {
            nameBlankOnSave = true
            valid = false
        } else {
            nameBlankOnSave = false
        }
        if desc.isEmpty {
            descBlankOnSave = true
            valid = false
        } else {
            descBlankOnSave = false
        }
        return valid
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $name)
                            .labelsHidden()
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
                        TextEditor(text: $desc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                    } header: {
                        Text("Description")
                    } footer: {
                        if descBlankOnSave {
                            Text("Description is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(descBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section {
                        GoalSelectionView(selectedGoals: $selectedGoals)
                    } header: {
                        Text("Goals")
                    } footer: {
                        if goalsBlankOnSave {
                            Text("Must select at least one Goal.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(goalsBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section {
                        withAnimation {
                            Toggle("Manual Add", isOn: $isManaualAdd.animation())
                        }
                        
                    }
                    if isManaualAdd {
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
                        
                        Section("Duration") {
                            DurationPickerView(hours: $manualDurationHours, minutes: $manualDurationMinutes)
                        }
                    }
                    
                }
            }
            .navigationTitle("Start New Activity")
            .toolbar {
                ToolbarItem {
                    Button(isManaualAdd ? "Save" : "Start") {
                        if (validateSave()) {
                            goals = Array(selectedGoals)
                            if isManaualAdd {
                                saveActivity(activityImage, true)
                            } else {
                                saveActivity(activityImage, false)
                                activityStatus = .started
                                startTime = Date()
                                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            }
                            dismiss()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
