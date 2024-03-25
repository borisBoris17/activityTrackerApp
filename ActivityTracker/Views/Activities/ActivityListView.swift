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
    @Binding var path: NavigationPath
    @FetchRequest var activities: FetchedResults<Activity>
    
    @State private var refreshingID = UUID()
    
    init(selectedDay: Date, activityFilter: ActivityFilter, geometry: GeometryProxy, path: Binding<NavigationPath>) {
        if activityFilter == .last30 {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)], predicate: NSPredicate(format: "%K > %@", "startDate", Calendar.current.date(byAdding: .day, value: -30, to: Date.now)! as NSDate))
        } else if activityFilter == .last7 {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)], predicate: NSPredicate(format: "%K > %@", "startDate", Calendar.current.date(byAdding: .day, value: -7, to: Date.now)! as NSDate))
        } else {
            _activities = FetchRequest<Activity>(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)], predicate: NSPredicate(format: "%K > %@ && %K < %@", "startDate", Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)! as NSDate, "startDate", Calendar.current.date(byAdding: .day, value: 1, to: selectedDay)! as NSDate))
        }
        self.selectedDay = selectedDay
        self.activityFilter = activityFilter
        self.geometry = geometry
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
            if activityFilter == .last30 {
                Text("Last 30 Days")
            } else if activityFilter == .last7 {
                Text("Last 7 Days")
            } else {
                Text("\(formattedDate(from:selectedDay))")
            }
        }
        .foregroundStyle(.brandColorDark)
        
        ForEach(activities) { activity in
            NavigationLink(value: activity) {
                ActivityCardView(activity: activity, geometry: geometry)
                    .padding(.bottom)
            }
        }
        .id(refreshingID)
    }
}

//#Preview {
//    ActivityListView(selectedDay: Date.now, showAll: false)
//}
