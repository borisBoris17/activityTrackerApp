//
//  PeopleView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import Foundation

extension PeopleView {
    
    @Observable
    class ViewModel {
        var isLoading = true
        var numPeople = 0
        var selectedPerson: Person? = nil
        var showAddPerson = false
        var imageHasChanged = false
        var refreshId = UUID()
    }
}
