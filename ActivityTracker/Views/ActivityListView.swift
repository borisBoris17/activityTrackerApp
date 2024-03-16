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
    var showAll: Bool
    var geometry: GeometryProxy
    @FetchRequest var activities: FetchedResults<Activity>
    
    @State private var refreshingID = UUID()
    
    init(selectedDay: Date, showAll: Bool, geometry: GeometryProxy) {
        if showAll {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)])
        } else {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)], predicate: NSPredicate(format: "%K > %@ && %K < %@", "startDate", Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)! as NSDate, "startDate", Calendar.current.date(byAdding: .day, value: 1, to: selectedDay)! as NSDate))
        }
        self.selectedDay = selectedDay
        self.showAll = showAll
        self.geometry = geometry
    }
    
    func formattedDate(from: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: from)
    }
    
    func deleteActivities(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let activity = activities[offset]
            for goal in activity.goalArray {
                goal.progress = goal.progress - Double(activity.duration)
            }
            
            // delete it from the context
            moc.delete(activity)
        }
        
        // save the context
        try? moc.save()
    }
    
    var body: some View {
        VStack {
            if showAll {
                Text("All Activities")
            } else {
                Text("\(formattedDate(from:selectedDay))")
            }
        }
        .foregroundStyle(.brandColorDark)
        
        ForEach(activities) { activity in
            NavigationLink {
                VStack {
                    ActivityView(activity: activity, refreshId: $refreshingID)
                }
            } label: {
                ActivityCardView(activity: activity, geometry: geometry)
                    .padding(.bottom)
            }
        }
        .onDelete(perform: deleteActivities)
        .id(refreshingID)
    }
}

//#Preview {
//    ActivityListView(selectedDay: Date.now, showAll: false)
//}
