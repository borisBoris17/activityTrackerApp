//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI

struct ActivityView: View {
    
    let activity: Activity
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var mode = "view"
    @State var updatedDuration = ""
    
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
                
                if mode == "view" {
                    Text("Duration")
                    Spacer()
                    Text(activity.formattedDuration + " Hours")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                } else {
                    Text("Duration")
                    Spacer()
                    TextField("Duration", text: $updatedDuration)
                        .multilineTextAlignment(.trailing)
                }
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
        .navigationBarTitle("Activity Detail", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup {
                if mode == "view" {
                    Button("Edit") {
                        updatedDuration = activity.formattedDuration
                        mode = "edit"
                    }
                    .padding()
                } else {
                    Button("Save") {
                        let newSeconds = (Double(updatedDuration) ?? 0.0) * Double(minuteLength) * Double(hourLength)
                        for goal in activity.goalArray {
                            goal.progress = goal.progress - Double(activity.duration) + newSeconds.rounded(.up)
                        }
                        
                        activity.duration = Int16(newSeconds.rounded(.up))
                        try? moc.save()
                        mode = "view"
                        dismiss()
                    }
                    .disabled(updatedDuration.isEmpty)
                    .padding()
                }
            }
        }
    }
    
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: Activity)
//    }
//}
