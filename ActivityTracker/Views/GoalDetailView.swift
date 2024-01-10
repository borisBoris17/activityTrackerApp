//
//  GoalDetailView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI

struct GoalDetailView: View {
    @State private var drawingStroke = false
    
    let goal: Goal
    
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
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Activities")
                                    .font(.title.bold())
                            }
                            Spacer()
                        }
                        
                        ForEach(goal.activityArray) { activity in
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
                            
                            if (goal.activityArray.firstIndex(of: activity) != goal.activityArray.count - 1) {
                                SeperatorView(height: 2, color: .secondary)
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationTitle(goal.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            drawingStroke = true
        }
    }
}

//struct GoalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalDetailView()
//    }
//}
