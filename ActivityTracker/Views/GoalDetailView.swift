//
//  GoalDetailView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI

struct GoalDetailView: View {
    @State private var drawingStroke = false
    @State private var showActivities = false
    
    @State private var refreshId = UUID()
    @State private var showEditGoal = false
    
    @State private var newGoalName = ""
    @State private var newGoalDesc = ""
    @State private var newGoalStartDate = Date()
    @State private var newGoalTarget = ""
    // Update when refactored to be an endDate
    @State private var newGoalDuration = ""
    
    let goal: Goal
    
    @Environment(\.managedObjectContext) var moc
    
    let animation = Animation
        .easeOut(duration: 1)
        .delay(0.25)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(.primary.opacity(0.5), lineWidth: 20)
                                    .frame(width: geometry.size.width * 0.7,
                                           height: geometry.size.width * 0.7)
                                
                                Circle()
                                    .trim(from: 0,
                                          to: drawingStroke ?
                                          goal.percentageDone
                                          : 0)
                                    .stroke(
                                        Color.primary,
                                        style: StrokeStyle(
                                            lineWidth: 20,
                                            lineCap: .round
                                        )
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .animation(animation, value: drawingStroke)
                                    .frame(width: geometry.size.width * 0.7,
                                           height: geometry.size.width * 0.7)
                                
                                
                                Text("\(goal.formattedProgress) / \(goal.target)")
                                    .font(.largeTitle.bold())
                                
                            }
                            .padding(.vertical)
                        }
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                if !goal.peopleArray.isEmpty {
                                    Text(goal.peopleArray[0].wrappedName )
                                        .font(.title.bold())
                                } else {
                                    Text("Unknown Person")
                                        .font(.title.bold())
                                }
                                Text("Starting: \(goal.formattedStartDate)")
                                    .foregroundColor(.secondary)
                                Text(goal.duration == 1 ? "Duration: \(goal.duration) Year" : "Duration: \(goal.duration) Years")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Activities") {
                                showActivities = true
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(goal.wrappedDesc)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $showActivities) {
                NavigationView {
                    List {
                        Section("Activities") {
                            ForEach(goal.descendingActivityArray) {activity in
                                NavigationLink {
                                    ActivityView(activity: activity, refreshId: $refreshId)
                                } label: {
                                    ActivityListItemView(activity: activity)
                                }
                            }
                            .id(refreshId)
                        }
                    }
                    .navigationTitle("\(goal.wrappedName) - Activities")
                }
                .presentationDetents([.height(geometry.size.height * 0.45), .medium, .large])
            }
        }
        .navigationTitle(goal.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    newGoalName = goal.wrappedName
                    newGoalDesc = goal.wrappedDesc
                    newGoalStartDate = goal.wrappedStartDate
                    newGoalTarget = "\(goal.target)"
                    newGoalDuration = "\(goal.duration)"
                    
                    showEditGoal = true
                }
            }
        }
        .onAppear {
            drawingStroke = true
        }
        .sheet(isPresented: $showEditGoal) {
            EditGoalView(newGoalName: $newGoalName, newGoalDesc: $newGoalDesc, newGoalStartDate: $newGoalStartDate, newGoalTarget: $newGoalTarget, newGoalDuration: $newGoalDuration) {
                goal.name = newGoalName
                goal.desc = newGoalDesc
                goal.startDate = newGoalStartDate
                goal.target = Int16(newGoalTarget) ?? 1000
                goal.duration = Int16(newGoalDuration) ?? 1
                
                try? moc.save()
            }
        }
    }
}

//struct GoalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalDetailView()
//    }
//}
