//
//  GoalsView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/03/2024.
//

import Foundation

extension GoalsView {
    
    @Observable
    class ViewModel {
        var showAddGoal = false
        var showAddPerson = false
        var personToAddGoal: Person?
    }
}
