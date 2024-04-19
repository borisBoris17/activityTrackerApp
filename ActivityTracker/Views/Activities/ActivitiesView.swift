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
    
    @State private var viewModel = ViewModel()
    
    @EnvironmentObject var refreshData: RefreshData
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        
                        if viewModel.activityStatus != .ready {
                            VStack {
                                Text(viewModel.name)
                                    .fontWeight(.bold)
                                
                                Text("\(viewModel.timerString())")
                                    .font(.system(size: 80).bold())
                                
                                HStack {
                                    if viewModel.activityStatus == .started {
                                        Button() {
                                            viewModel.pauseTimer()
                                        } label: {
                                            Label("Pause Timer", systemImage: "pause")
                                        }
                                        .buttonStyle(BlueButton())
                                    } else if viewModel.activityStatus == .paused {
                                        Button() {
                                            viewModel.resumeTimer()
                                        } label: {
                                            Label("Resume Timer", systemImage: "play")
                                        }
                                        .buttonStyle(BlueButton())
                                    }
                                    
                                    Button() {
                                        viewModel.showCompleteActivityScreen = true
                                    } label: {
                                        Label("Save Activity", systemImage: "stop")
                                    }
                                    .buttonStyle(BlueButton())
                                }
                            }
                            .padding(.top)
                        }
                        
                        
                        VStack {
                            HorizonalDateSelectView(startingSunday: $viewModel.startingSunday, startingSundayDay: Calendar.current.dateComponents([.day], from: viewModel.startingSunday).day!, startingSundayMonth: Calendar.current.dateComponents([.month], from: viewModel.startingSunday).month!, selectedDay: $viewModel.selectedDay)
                            
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
                        StartActivityView(geometry: geometry, name: $viewModel.name, desc: $viewModel.desc, goals: $viewModel.selectedGoals, timer: $viewModel.timer, activityStatus: $viewModel.activityStatus, startTime: $viewModel.startTime, manualDurationHours: $viewModel.manualHours, manualDurationMinutes: $viewModel.manualMinutes, saveActivity: { activityImage, isManual in
                            
                            viewModel.create(activity: Activity(context: moc))
                            if isManual {
                                viewModel.complete(with: activityImage, isManual: true)
                            }
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                        })
                    }
                    .sheet(isPresented: $viewModel.showCompleteActivityScreen) {
                        SaveActivityView(name: $viewModel.name, desc: $viewModel.desc, timer: $viewModel.timer, saveActivity: { activityImage in
                            //                            if let activity = viewModel.currentActivty {
                            viewModel.complete(with: activityImage, isManual: false)
                            
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                            //                            }
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
            .navigationDestination(for: Goal.self) { goal in
                VStack {
                    GoalDetailView(goal: goal, path: $path)
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityView(activity: activity, path: $path)
            }
        }
    }
}

//struct ActivitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivitiesView()
//    }
//}
