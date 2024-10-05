//
//  StartActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI
import CoreData
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
    @Binding var startTimeHours: Int
    @Binding var startTimeMinutes: Int
    @Binding var totalSeconds: Int
    @Binding var manualDate: Date
    var saveActivity: ( _ activityImage: Image?, _ isManual: Bool) -> Void
    
    @State private var selectedGoals = Set<Goal>()
    @State private var isManaualAdd = false
    @State private var activityPhotoItem: PhotosPickerItem?
    @State private var activityImageData: Data?
    @State private var activityImage: Image?
    @State private var nameBlankOnSave = false
    @State private var goalsBlankOnSave = false
    
    @State private var isShowingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var isLoadingCaptureImage = false
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: false), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var allGoals: FetchedResults<Goal>
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var filteredNames: [String] = []
    @State private var suggestionSelected: Bool = false
    
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
        return valid
    }
    
    private func fetchSuggestions(for query: String) {
        if query.isEmpty {
            filteredNames = []
            return
        }
        
        let request: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Activity")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["name"]
        request.returnsDistinctResults = true
        request.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", query)
        
        do {
            let results = try viewContext.fetch(request)
            filteredNames = results.compactMap { $0["name"] as? String }
                                .filter { $0.lowercased() != query.lowercased() }
        } catch {
            print("Failed to fetch suggestions: \(error)")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $name)
                            .labelsHidden()
                            .onChange(of: name) {
                                if !suggestionSelected {
                                    fetchSuggestions(for: name)
                                }
                                suggestionSelected = false
                            }
                        if !filteredNames.isEmpty {
                                List(filteredNames, id: \.self) { filteredName in
                                    Text(filteredName).onTapGesture {
                                        name = filteredName
                                        filteredNames = []
                                        suggestionSelected = true
                                    }
                                }
                            }
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
                    }
                    
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
                    
                    Section() {
                        DurationPickerView(hours: $startTimeHours, minutes: $startTimeMinutes)
                    } header : {
                        Text("Starting Time")
                    } footer : {
                        Text ("Enter how long ago the activity started.")
                    }
                    
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
                            
                            HStack {
                                Button("Capture Image") {
                                    isShowingImagePicker = true
                                }
                                .sheet(isPresented: $isShowingImagePicker) {
                                    ImagePicker(selectedImage: $capturedImage)
                                }
                                .onChange(of: capturedImage) {
                                    guard let capturedImage else { return }
                                    activityImage = Image(uiImage: capturedImage)
                                }
                                
                                Spacer()
                                
                                if isShowingImagePicker {
                                    Spacer()
                                    
                                    ProgressView()
                                }
                            }
                        }
                        
                        Section("Date") {
                            // DatePicker where only a date in the past can be selected
                            
                            DatePicker(
                                "Date of Activity",
                                selection: $manualDate,
                                in: ...Date.now,
                                displayedComponents: [.date]
                            )
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
                                totalSeconds = 0
                                if (startTimeHours > 0) {
                                    totalSeconds += Int(startTimeHours) * 60 * 60
                                    startTime = startTime.addingTimeInterval(-Double(startTimeHours) * 60 * 60)
                                }
                                if (startTimeMinutes > 0) {
                                    totalSeconds += Int(startTimeMinutes) * 60
                                    startTime = startTime.addingTimeInterval(-Double(startTimeMinutes) * 60)
                                }
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
