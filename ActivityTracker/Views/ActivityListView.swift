//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 01/01/2024.
//

import SwiftUI

struct ActivityListView: View {
    var selectedDay: Date
    @FetchRequest var activities: FetchedResults<Activity>
    
    init(selectedDay: Date) {
        _activities = FetchRequest<Activity>(sortDescriptors: [], predicate: NSPredicate(format: "%K > %@ && %K < %@", "startDate", Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)! as NSDate, "startDate", Calendar.current.date(byAdding: .day, value: 1, to: selectedDay)! as NSDate))
        self.selectedDay = selectedDay
    }
    
    func formattedDate(from: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: from)
    }
    
    var body: some View {
        List {
            Section {
                ForEach(activities) { activity in
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text(activity.wrappedName)
                            Text("\(activity.formattedDuration) hour")
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
            } header: {
                Text("\(formattedDate(from:selectedDay))")
            }
        }
    }
}

#Preview {
    ActivityListView(selectedDay: Date.now)
}
