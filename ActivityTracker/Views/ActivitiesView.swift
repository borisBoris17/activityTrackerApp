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
    
    @State private var showNewActivitySheet = false
    @State private var activityStatus = ActivityStatus.ready
    
    @State private var showAll = false
    
    @State private var showCompleteActivityScreen = false
    @State private var activityToSave = Activity()
    
    @State private var startTime =  Date()
    @State private var pausedSeconds = 0
    @State private var totalSeconds = 0
    
    @State private var name = ""
    @State private var desc = ""
    @State private var selectedGoals: [Goal] = []
    @State private var day = Date.now
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var startingSunday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(Calendar.current.component(.weekday, from: Date.now) - 1), to: Date.now)!)
    
    @State private var selectedDay = Calendar.current.startOfDay(for: Date.now)
    
    func timerString() -> String {
        let seconds = String(format: "%02d", totalSeconds % minuteLength)
        let minutes = String(format: "%02d", (totalSeconds / minuteLength) % hourLength)
        let hours = String(format: "%02d", totalSeconds / (minuteLength * hourLength))
        return hours == "00" ? "\(minutes):\(seconds)" : "\(hours):\(minutes):\(seconds)"
    }
    
    var body: some View {
        let timerBinding = Binding(
            get: { self.timer },
            set: { self.timer = $0 }
        )
        
        let startTimeBinding = Binding(
            get: { self.startTime },
            set: { self.startTime = $0 }
        )
        
        let activityStatusBinding = Binding(
            get: { self.activityStatus },
            set: { self.activityStatus = $0 }
        )
        
        let nameBinding = Binding(
            get: { self.name },
            set: { self.name = $0 }
        )
        
        let descBinding = Binding(
            get: { self.desc },
            set: { self.desc = $0 }
        )
        
        let goalsBinding = Binding(
            get: { self.selectedGoals },
            set: { self.selectedGoals = $0 }
        )
        
        let startingSundayBinding = Binding(
            get: { self.startingSunday },
            set: { self.startingSunday = $0 }
        )
        
        let selectedDayBinding = Binding(
            get: { self.selectedDay },
            set: { self.selectedDay = $0 }
        )
        
        ZStack {
            VStack {
                
                if activityStatus != .ready {
                    VStack {
                        Text("\(timerString())")
                            .font(.system(size: 80).bold())
                        
                        HStack {
                            if activityStatus == .started {
                                Button() {
                                    pausedSeconds = totalSeconds
                                    timer.upstream.connect().cancel()
                                    activityStatus = .paused
                                } label: {
                                    Label("Pause Timer", systemImage: "pause")
                                }
                                .buttonStyle(BlueButton())
                            } else if activityStatus == .paused {
                                Button() {
                                    startTime = Date()
                                    activityStatus = .started
                                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                } label: {
                                    Label("Resume Timer", systemImage: "play")
                                }
                                .buttonStyle(BlueButton())
                            }
                            
                            Button() {
                                showCompleteActivityScreen = true
                            } label: {
                                Label("Save Activity", systemImage: "stop")
                            }
                            .buttonStyle(BlueButton())
                        }
                    }
                }
                
                
                VStack {
                    HorizonalDateSelectView(startingSunday: startingSundayBinding, startingSundayDay: Calendar.current.dateComponents([.day], from: startingSunday).day!, startingSundayMonth: Calendar.current.dateComponents([.month], from: startingSunday).month!, selectedDay: selectedDayBinding)
                    
                    ActivityListView(selectedDay: selectedDay, showAll: showAll)
                }
                .padding(.top)
            }
            .onReceive(timer) { _ in
//                totalSeconds = pausedSeconds + Int(Date().timeIntervalSince(startTime)) -- add one second to the timer (normal case)
                totalSeconds = pausedSeconds + (Int(Date().timeIntervalSince(startTime)) * 900) // add 15 minutes at a time
            }
            .onAppear {
                if activityStatus == .started {
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                } else {
                    timer.upstream.connect().cancel()
                }
            }
            .sheet(isPresented: $showNewActivitySheet) {
                StartActivityView(name: nameBinding, desc: descBinding, goals: goalsBinding, timer: timerBinding, activityStatus: activityStatusBinding, startTime: startTimeBinding)
            }
            .sheet(isPresented: $showCompleteActivityScreen) {
                SaveActivityView(name: nameBinding, desc: descBinding, timer: timerBinding, saveActivity: { activityImage in
                    let newActivity = Activity(context: moc)
                    newActivity.id = UUID()
                    newActivity.name = name
                    newActivity.desc = desc
                    newActivity.goals = NSSet(array: selectedGoals)
                    newActivity.duration = Int16(totalSeconds)
                    newActivity.startDate = Calendar.current.startOfDay(for: Date.now)
                    
                    activityToSave = newActivity
                    
                    if activityImage != nil {
                        let renderer = ImageRenderer(content: activityImage)
                        if let uiImage = renderer.uiImage {
                            if let data = uiImage.pngData() {
                                let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(newActivity.id!).png")
                                try? data.write(to: filename)
                            }
                        }
                    }
                    
                    // Update all of the Goals. Add the duration to the progress
                    for goal in selectedGoals {
                        goal.progress = goal.progress + Double(totalSeconds)
                    }
                    
                    try? moc.save()
                    
                    pausedSeconds = 0
                    totalSeconds = 0
                    activityStatus = .ready
                    name = ""
                    desc = ""
                    timer.upstream.connect().cancel()
                })
            }
            if activityStatus == .ready {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button() {
                            showNewActivitySheet = true
                        } label : {
                            Label("Add New Activity", systemImage: "plus")
                        }
                        .buttonStyle(BlueButton())
                    }
                }
            }
        }
        .navigationTitle("Activities")
        .toolbar {
            ToolbarItem {
                Button(showAll ? "By Date" : "Show All") {
                    showAll.toggle()
                }
                .padding()
            }
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
