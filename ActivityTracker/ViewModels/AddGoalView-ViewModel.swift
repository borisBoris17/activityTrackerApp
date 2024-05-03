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
        //                        .disabled(viewModel.newGoalName.isEmpty || viewModel.newGoalPerson == -1 || viewModel.newGoalTarget.isEmpty)
        var goalNameBlankOnSave = false
        var personBlankOnSave = false
        var goalTargetBlankOnSave = false
        
        func validateSave() -> Bool {
            var valid = true
            if newGoalName.isEmpty {
                goalNameBlankOnSave = true
                valid = false
            } else {
                goalNameBlankOnSave = false
            }
            if newGoalPerson == -1 {
                personBlankOnSave = true
                valid = false
            } else {
                personBlankOnSave = false
            }
            if newGoalTarget.isEmpty {
                goalTargetBlankOnSave = true
                valid = false
            } else {
                if let parsedTarget = Int16(newGoalTarget) {
                    if parsedTarget >= 0 {
                        goalTargetBlankOnSave = false
                    } else {
                        goalTargetBlankOnSave = true
                        valid = false
                    }
                } else {
                    goalTargetBlankOnSave = true
                    valid = false
                }
            }
            return valid
        }
        
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
