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
    @State var updatedName = ""
    @State var updatedDescription = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            Form {
                HStack(alignment: .top) {
                    if mode == "view" {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.wrappedName)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextField("Name", text: $updatedName)
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
                
                HStack(alignment: .top) {
                    if mode == "view" {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.wrappedDesc)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextEditor( text: $updatedDescription)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
                
                HStack(alignment: .top) {
                    Text("Goals")
                        .frame(width: geometry.size.width * 0.3, alignment: .leading)
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
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        Text(activity.formattedDuration + " Hours")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("Duration")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextField("Duration", text: $updatedDuration)
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
                
                HStack(alignment: .top) {
                    Text("Date")
                        .frame(width: geometry.size.width * 0.3, alignment: .leading)
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
                            updatedName = activity.wrappedName
                            updatedDescription = activity.wrappedDesc
                            withAnimation {
                                mode = "edit"
                            }
                        }
                        .padding()
                    } else {
                        Button("Save") {
                            let newSeconds = (Double(updatedDuration) ?? 0.0) * Double(minuteLength) * Double(hourLength)
                            for goal in activity.goalArray {
                                goal.progress = goal.progress - Double(activity.duration) + newSeconds.rounded(.up)
                            }
                            
                            activity.duration = Int16(newSeconds.rounded(.up))
                            activity.name = updatedName
                            activity.desc = updatedDescription
                            try? moc.save()
                            withAnimation {
                                mode = "view"
                            }
                            //                        dismiss()
                        }
                        .disabled(updatedDuration.isEmpty)
                        .padding()
                    }
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
