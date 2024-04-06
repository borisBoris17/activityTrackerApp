//
//  AddGoalView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import Foundation

extension AddGoalView {
    @Observable
    class ViewModel {
        var newGoalName = ""
        var newGoalDesc = ""
        var newGoalPerson = -1
        var newGoalStartDate = Date.now
        var newGoalEndDate = Calendar.current.date(byAdding: .year, value: 1, to: Date.init())!
        var newGoalTarget = ""
        var newGoalProgreess = ""
        var newGoalPeople: Set<Person> = []
        
        func create(newGoal goal: Goal, for person: Person) {
            goal.id = UUID()
            goal.name = newGoalName
            goal.desc = newGoalDesc
            goal.target = Int16(newGoalTarget) ?? 1000
            goal.startDate = newGoalStartDate
            goal.endDate = newGoalEndDate
            goal.progress = (Double(newGoalProgreess) ?? 0) * Double(minuteLength) * Double(hourLength)
            goal.people = [person]
        }
    }
}
