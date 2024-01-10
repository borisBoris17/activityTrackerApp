//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI

enum ActivityStatus {
    case ready, started, paused, stoped
}

struct ActivityView: View {
    
    let activity: Activity
    
    var body: some View {
        Form {
            HStack(alignment: .top) {
                Text("Name")
                Spacer()
                Text(activity.wrappedName)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack(alignment: .top) {
                Text("Description")
                Spacer()
                Text(activity.wrappedDesc)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack(alignment: .top) {
                Text("Goals")
                Spacer()
                VStack(alignment: .trailing) {
                    ForEach(activity.goalArray) { goal in
                        ForEach(goal.peopleArray) { person in
                            Text("\(person.wrappedName) - \(goal.wrappedName)" )
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            HStack(alignment: .top) {
                Text("Duration")
                Spacer()
                Text(activity.formattedDuration + " Hours")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack(alignment: .top) {
                Text("Date")
                Spacer()
                Text(activity.wrappedStartDate.formatted(.dateTime.day().month().year()))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.top)
//        .navigationBarTitle(activity.wrappedName, displayMode: .inline)
        .navigationBarTitle("Activity Detail", displayMode: .inline)
    }
    
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: Activity)
//    }
//}
