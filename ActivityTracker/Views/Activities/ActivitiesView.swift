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
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    
    @Binding var path: NavigationPath
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        
                        if viewModel.activityStatus != .ready {
                            VStack {
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
                            
                            ActivityListView(selectedDay: viewModel.selectedDay, activityFilter: viewModel.activityFilter, geometry: geometry, path: $path)
                        }
                        .background(.neutralLight)
                        .padding()
                    }
                    .onReceive(viewModel.timer) { _ in
                        viewModel.handleRecieveTimer()
                    }
                    .onAppear {
                        viewModel.updateTimer()
                    }
                    .sheet(isPresented: $viewModel.showNewActivitySheet) {
                        StartActivityView(name: $viewModel.name, desc: $viewModel.desc, goals: $viewModel.selectedGoals, timer: $viewModel.timer, activityStatus: $viewModel.activityStatus, startTime: $viewModel.startTime)
                    }
                    .sheet(isPresented: $viewModel.showCompleteActivityScreen) {
                        SaveActivityView(name: $viewModel.name, desc: $viewModel.desc, timer: $viewModel.timer, saveActivity: { activityImage in
                            viewModel.create(newActivity: Activity(context: moc), with: activityImage)
                            
                            try? moc.save()
                            
                        })
                    }
                    
                }
                .background(.neutralLight)
                .navigationTitle("Activities")
                .toolbar {
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
                ActivityView(activity: activity, refreshId: $viewModel.refreshId, path: $path)
            }
        }
    }
}

//struct ActivitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivitiesView()
//    }
//}
