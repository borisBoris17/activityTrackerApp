//
//  ActivitiesView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI

let minuteLength = 60
let hourLength = 60

enum ActivityStatus {
    case ready, started, paused, stoped
}

enum ActivityFilter {
    case selectedDay, last7, last30
}

struct ActivitiesView: View {
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: false), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var goals: FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    
    @Binding var path: NavigationPath
    @Binding var selection: Int
    
    @State private var viewModel = ViewModel()
    @State private var activityImage: Image?
    @State private var capturedImage: UIImage?
    @State private var isLoadingCaptureImage = false
    
    @EnvironmentObject var refreshData: RefreshData
    @Environment(\.scenePhase) var scenePhase
    
    var iconSize: CGFloat = 60
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        
                        if viewModel.activityStatus != .ready {
                            ZStack {
                                
                                activityImage?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.95)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                VStack {
                                    VStack {
                                        Text(viewModel.name)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.brandText)
                                        VStack(alignment:.leading) {
                                            Text("\(viewModel.timerString())")
                                                .font(.system(size: 75).bold())
                                                .foregroundStyle(.brandText)
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.85)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .opacity(0.4)
                                            .cornerRadius(15)
                                    )
                                    .padding(.top)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        if viewModel.activityStatus == .started {
                                            Button() {
                                                viewModel.pauseTimer()
                                            } label: {
                                                Label("Pause Timer", systemImage: "pause")
                                                    .frame(width: iconSize, height: iconSize)
                                            }
                                            .buttonStyle(BlueButton())
                                        } else if viewModel.activityStatus == .paused {
                                            Button() {
                                                viewModel.resumeTimer()
                                            } label: {
                                                Label("Resume Timer", systemImage: "play")
                                                    .frame(width: iconSize, height: iconSize)
                                            }
                                            .buttonStyle(BlueButton())
                                        }
                                        
                                        Button() {
                                            viewModel.pauseTimer()
                                            viewModel.showCompleteActivityScreen = true
                                        } label: {
                                            Label("Save Activity", systemImage: "stop")
                                                .frame(width: iconSize, height: iconSize)
                                        }
                                        .buttonStyle(BlueButton())
                                        
                                        
                                        if capturedImage != nil {
                                            Button() {
                                                capturedImage = nil
                                                activityImage = nil
                                                isLoadingCaptureImage = false
                                            } label: {
                                                Label("Remove Photo", systemImage: "trash")
                                                    .frame(width: iconSize, height: iconSize)
                                            }
                                            .buttonStyle(BlueButton())
                                        } else {
                                            CaptureImageView(capturedImage: $capturedImage, activityImage: $activityImage, isLoading: $isLoadingCaptureImage) {
                                                Label("Add Photo", systemImage: "camera")
                                                    .frame(width: iconSize, height: iconSize)
                                                    .opacity(isLoadingCaptureImage ? 0.5 : 1)
                                            }
                                            .buttonStyle(BlueButton())
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                        
                        
                        VStack {
                            HorizonalDateSelectView(startingSunday: $viewModel.startingSunday, startingSundayDay: Calendar.current.dateComponents([.day], from: viewModel.startingSunday).day!, startingSundayMonth: Calendar.current.dateComponents([.month], from: viewModel.startingSunday).month!, selectedDay: $viewModel.selectedDay)
                            
                            if goals.count == 0 {
                                Text("Before Starting An Activity A Person And Goal Must Be Added.")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.brandColorDark)
                                
                                if people.count == 0 {
                                    Button {
                                        selection = 3
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Label("Add a Person", systemImage: "plus")
                                                .font(.title)
                                                .padding()
                                            Spacer()
                                        }
                                        .frame(maxWidth: nil)
                                        .background(.brand, in: RoundedRectangle(cornerRadius: 16))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Button {
                                        selection = 1
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Label("Add a Goal", systemImage: "plus")
                                                .font(.title)
                                                .padding()
                                            Spacer()
                                        }
                                        .frame(maxWidth: nil)
                                        .background(.brand, in: RoundedRectangle(cornerRadius: 16))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            } else {
                                if viewModel.activityStatus == .ready {
                                    Button {
                                        viewModel.showNewActivitySheet = true
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Label("Start a new Activity", systemImage: "plus")
                                                .font(.title)
                                                .padding()
                                            Spacer()
                                        }
                                        .frame(maxWidth: nil)
                                        .background(.brand, in: RoundedRectangle(cornerRadius: 16))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                ActivityListView(selectedDay: viewModel.selectedDay, activityFilter: viewModel.activityFilter, geometry: geometry, currentActivity: viewModel.currentActivty, path: $path)
                            }
                        }
                        .background(.neutralLight)
                        .padding()
                    }
                    .onReceive(viewModel.timer) { _ in
                        viewModel.handleRecieveTimer(moc)
                    }
                    .onAppear {
                        viewModel.updateTimer()
                    }
                    .sheet(isPresented: $viewModel.showNewActivitySheet) {
                        StartActivityView(geometry: geometry, name: $viewModel.name, desc: $viewModel.desc, goals: $viewModel.selectedGoals, timer: $viewModel.timer, activityStatus: $viewModel.activityStatus, startTime: $viewModel.startTime, manualDurationHours: $viewModel.manualHours, manualDurationMinutes: $viewModel.manualMinutes, startTimeHours: $viewModel.startTimeHours, startTimeMinutes: $viewModel.startTimeMinutes, totalSeconds: $viewModel.totalSeconds, manualDate: $viewModel.startDate, saveActivity: { activityImage, isManual in
                            
                            viewModel.create(activity: Activity(context: moc))
                            if isManual {
                                viewModel.complete(with: activityImage, isManual: true)
                            }
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                        })
                    }
                    .sheet(isPresented: $viewModel.showCompleteActivityScreen, onDismiss: {
                        if viewModel.activityStatus != .ready {
                            viewModel.resumeTimer()
                        }
                    }) {
                        SaveActivityView(name: $viewModel.name, desc: $viewModel.desc, timer: $viewModel.timer, activityImage: $activityImage, saveActivity: { activityImage in
                            viewModel.complete(with: activityImage, isManual: false)
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                            capturedImage = nil
                            self.activityImage = nil
                            isLoadingCaptureImage = false
                        })
                    }
                    
                }
                .background(.neutralLight)
                .navigationBarTitle("Activities", displayMode: .inline)
                .toolbar {
                    if viewModel.activityFilter == .selectedDay {
                        ToolbarItem(placement: .navigationBarLeading) {
                            DatePicker(
                                "Select Day",
                                selection: $viewModel.selectedDay,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                        }
                    }
                    
                    ToolbarItem {
                        Menu("Filter") {
                            Button("Selected Date") {
                                viewModel.activityFilter = .selectedDay
                            }
                            Button("Last 7 Days") {
                                viewModel.activityFilter = .last7
                            }
                            Button("Last 30 Days") {
                                viewModel.activityFilter = .last30
                            }
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    if (viewModel.currentActivty != nil) {
                        viewModel.updateDuration(activity: viewModel.currentActivty!, isManual: false)
                        try? moc.save()
                    }
                }
            }
            .navigationDestination(for: Goal.self) { goal in
                VStack {
                    GoalDetailView(goal: goal, path: $path)
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityView(activity: activity, path: $path)
            }
            .onAppear() {
                viewModel.selectedDay = Date()
            }
        }
    }
}

//struct ActivitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivitiesView()
//    }
//}
