//
//  ActivitiesView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI

let minuteLength = 3
let hourLength = 3

struct ActivitiesView: View {
    
    @FetchRequest(sortDescriptors: []) var activities: FetchedResults<Activity>
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    
    @State private var showNewActivitySheet = false
    @State private var activityStatus = ActivityStatus.ready
    
    @State private var startTime =  Date()
    @State private var pausedSeconds = 0
    @State private var totalSeconds = 0
//    @State private var timerString = "00:00"
    
    @State private var name = ""
    @State private var desc = ""
    @State private var selectedGoal: Goal? = nil
    @State private var selectedGoals: [Goal] = []
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
        
        let goalBinding = Binding(
            get: { self.selectedGoal },
            set: { self.selectedGoal = $0 }
        )
        
        let goalsBinding = Binding(
            get: { self.selectedGoals },
            set: { self.selectedGoals = $0 }
        )
        
        VStack {
            HStack {
                Text("Activities")
                    .font(.system(size: 50).bold())
                    .padding(.leading)
                
                Spacer()
            }
            
            if activityStatus == .ready {
                Button("Start New Activity") {
                    showNewActivitySheet = true
                }
                .buttonStyle(BlueButton())
            } else {
                VStack {
                    Text("\(timerString())")
                        .font(.system(size: 80).bold())
                    
                    if activityStatus == .started {
                        Button("Pause") {
                            pausedSeconds = totalSeconds
                            timer.upstream.connect().cancel()
                            activityStatus = .paused
                        }
                        .buttonStyle(BlueButton())
                    } else if activityStatus == .paused {
                        Button("Resume") {
                            startTime = Date()
                            activityStatus = .started
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        }
                        //                .disabled(disableTimer())
                        .buttonStyle(BlueButton())
                    }
                    
                    Button("Save") {
                        // save the Activity
                        // create an Activity object then save the object
                        let newActivity = Activity(context: moc)
                        newActivity.id = UUID()
                        newActivity.name = name
                        newActivity.desc = desc
//                        newActivity.goals = [selectedGoal!]
                        newActivity.goals = NSSet(array: selectedGoals)
                        newActivity.duration = Int16(totalSeconds / (minuteLength * hourLength))
                        
                        try? moc.save()
                        
                        pausedSeconds = 0
                        totalSeconds = 0
                        activityStatus = .ready
                    }
                }
            }
            
            
            List {
                ForEach(activities) { activity in
                    HStack {
//                        Image(systemName: "clock")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text(activity.wrappedName)
                            Text("\(activity.duration) hour")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            ForEach(activity.goalArray) { goal in
                                if !goal.peopleArray.isEmpty { Text("\(goal.peopleArray[0].wrappedName) - \(goal.wrappedName)")
                                } else {
                                    Text("\("unknwn person") - \(goal.wrappedName)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            totalSeconds = pausedSeconds + Int(Date().timeIntervalSince(startTime))
        }
        .onAppear {
            timer.upstream.connect().cancel()
        }
        .sheet(isPresented: $showNewActivitySheet) {
            StartActivityView(name: nameBinding, desc: descBinding, goals: goalsBinding, timer: timerBinding, activityStatus: activityStatusBinding, startTime: startTimeBinding)
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
