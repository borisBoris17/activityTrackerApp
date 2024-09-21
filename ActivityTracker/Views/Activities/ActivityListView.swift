//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 01/01/2024.
//

import SwiftUI

struct ActivityListView: View {
    @Environment(\.managedObjectContext) var moc
    var selectedDay: Date
    var activityFilter: ActivityFilter
    var geometry: GeometryProxy
    var currentActivity: Activity?
    @Binding var path: NavigationPath
    @FetchRequest var activities: FetchedResults<Activity>
    @State private var allGoalsForActivities: [Goal : Int32] = [:]
    @State private var showGoalSummraie = true
    
    @EnvironmentObject var refreshData: RefreshData
    
    init(selectedDay: Date, activityFilter: ActivityFilter, geometry: GeometryProxy, currentActivity: Activity?, path: Binding<NavigationPath>) {
        if activityFilter == .last30 {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false), NSSortDescriptor(keyPath: \Activity.duration, ascending: false)], predicate: NSPredicate(format: "%K > %@", "startDate", Calendar.current.date(byAdding: .day, value: -30, to: Date.now)! as NSDate))
        } else if activityFilter == .last7 {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false), NSSortDescriptor(keyPath: \Activity.duration, ascending: false)], predicate: NSPredicate(format: "%K > %@", "startDate", Calendar.current.date(byAdding: .day, value: -7, to: Date.now)! as NSDate))
        } else {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false), NSSortDescriptor(keyPath: \Activity.duration, ascending: false)], predicate: NSPredicate(format: "%K > %@ && %K < %@", "startDate", Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)! as NSDate, "startDate", Calendar.current.date(byAdding: .day, value: 1, to: selectedDay)! as NSDate))
        }
        self.selectedDay = selectedDay
        self.activityFilter = activityFilter
        self.geometry = geometry
        self.currentActivity = currentActivity
        self._path = path
    }
    
    func formattedDate(from: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: from)
    }
    
    var body: some View {
        VStack {
            VStack {
                if activityFilter == .last30 {
                    Text("Last 30 Days")
                } else if activityFilter == .last7 {
                    Text("Last 7 Days")
                } else {
                    Text("\(formattedDate(from:selectedDay))")
                }
            }
            .foregroundStyle(.brandColorDark)
            
            
            
            VStack {
                
                Button {
                    withAnimation {
                        showGoalSummraie.toggle()
                    }
                } label: {
                    HStack {
                        Text("Goal Summaries")
                        
                        Spacer()
                        
                        showGoalSummraie ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                    }
                    .foregroundColor(.brandColorDark)
                }
                
                if (showGoalSummraie) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(allGoalsForActivities.keys), id: \.self) { goal in
                                GoalPeriodSummaryView(goal: goal, periodTotal: allGoalsForActivities[goal] ?? 0)
                            }
                        }
                    }
                    
                }
            }
            
            ForEach(activities) { activity in
                if activity.id != currentActivity?.id {
                    NavigationLink(value: activity) {
                        ActivityCardView(activity: activity, geometry: geometry)
                            .padding(.bottom)
                    }
                }
            }
            .id(refreshData.activityRefreshId)
        }
        .onChange(of: Array(activities)) {
            if activities.count == 0 {
                allGoalsForActivities = [:]
                return
            }
            var allGoals: [Goal : Int32] = [:]
            
            activities.forEach { activity in
                activity.goalArray.forEach { goal in
                    if allGoals[goal] != nil {
                        allGoals[goal] = allGoals[goal]! + activity.duration
                    } else {
                        allGoals[goal] = activity.duration
                    }
                }
            }
            allGoalsForActivities = allGoals
        }
    }
}

//#Preview {
//    ActivityListView(selectedDay: Date.now, showAll: false)
//}
