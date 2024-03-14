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

struct ActivitiesView: View {
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
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
                    
                    
                    LazyVStack {
                        HorizonalDateSelectView(startingSunday: $viewModel.startingSunday, startingSundayDay: Calendar.current.dateComponents([.day], from: viewModel.startingSunday).day!, startingSundayMonth: Calendar.current.dateComponents([.month], from: viewModel.startingSunday).month!, selectedDay: $viewModel.selectedDay)
                        
                        ActivityListView(selectedDay: viewModel.selectedDay, showAll: viewModel.showAll, geometry: geometry)
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
                if viewModel.activityStatus == .ready {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button() {
                                viewModel.showNewActivitySheet = true
                            } label : {
                                Label("Add New Activity", systemImage: "plus")
                            }
                            .buttonStyle(BlueButton())
                        }
                    }
                }
                
            }
            .background(.neutralLight)
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem {
                    Button(viewModel.showAll ? "By Date" : "Show All") {
                        viewModel.showAll.toggle()
                    }
                    .foregroundStyle(.brandColorDark)
                    .padding()
                }
            }
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
