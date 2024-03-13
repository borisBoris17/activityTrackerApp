//
//  AddGoalToPersonView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/03/2024.
//

import Foundation

extension AddGoalToPersonView {
    
    @Observable
    class ViewModel {
        var newGoalName = ""
        var newGoalDesc = ""
        var newGoalStartDate = Date.now
        var newGoalEndDate = Date.now
        var newGoalTarget = ""
        var newGoalProgreess = ""
        
        func create(newGoal goal: Goal, for person: Person) {
            goal.id = UUID()
            goal.name = newGoalName
            goal.desc = newGoalDesc
            goal.target = Int16(newGoalTarget) ?? 1000
            goal.startDate = newGoalStartDate
            goal.endDate = newGoalEndDate
            goal.progress = (Double(newGoalProgreess) ?? 1) * Double(minuteLength) * Double(hourLength)
            goal.people = [person]
        }
    }
}
