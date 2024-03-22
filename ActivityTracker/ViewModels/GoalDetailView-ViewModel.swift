//
//  GoalDetailView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/03/2024.
//

import Foundation

extension GoalDetailView {
    @Observable
    class ViewModel {
        var drawingStroke = false
        var showActivities = false
        
        var refreshId = UUID()
        var showEditGoal = false
        
        var newGoalName = ""
        var newGoalDesc = ""
        var newGoalStartDate = Date()
        var newGoalEndDate = Date()
        var newGoalTarget = ""
        var isDelete = false
        
        func prepareForEdit(for goal: Goal) {
            newGoalName = goal.wrappedName
            newGoalDesc = goal.wrappedDesc
            newGoalStartDate = goal.wrappedStartDate
            newGoalEndDate = goal.wrappedEndDate
            newGoalTarget = "\(goal.target)"
            
            showEditGoal = true
        }
        
        func update(_ goal: Goal) {
            goal.name = newGoalName
            goal.desc = newGoalDesc
            goal.startDate = newGoalStartDate
            goal.endDate = newGoalEndDate
            goal.target = Int16(newGoalTarget) ?? 1000
        }
    }
}
