//
//  ActivityListItemView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 21/02/2024.
//

import SwiftUI

struct ActivityListItemView: View {
    var activity: Activity
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(activity.wrappedName)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
                Spacer()
                
                VStack(alignment: .leading) {
                    ForEach(activity.goalArray) { goal in
                        if !goal.peopleArray.isEmpty {
                            Text("\(goal.peopleArray[0].wrappedName) - \(goal.wrappedName)")
                                .lineLimit(1)
                                .foregroundColor(.primary)
                        } else {
                            Text("\("unknwn person") - \(goal.wrappedName)")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            Text("\(activity.formattedDuration) hour")
                .foregroundColor(.secondary)
        }
    }
}

//#Preview {
//    ActivityListItemView()
//}
