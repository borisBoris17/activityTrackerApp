//
//  GoalSelectionView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/09/2023.
//

import SwiftUI

struct GoalSelectionView: View {
    
    @State private var selectedPerson = -1
    @State private var selectedGoal = -1
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    
    var body: some View {
        Section {
            Picker("Person", selection: $selectedPerson) {
                Text("None").tag(-1)
                ForEach(0 ..< people.count, id: \.self) { i in
                    Text("\(people[i].wrappedName)").tag(i as Int?)
                }
            }
            
            Picker("Goal", selection: $selectedGoal) {
                Text("None").tag(-1)
                ForEach(0 ..< filteredGoals().count, id: \.self) { i in
                    Text("\(goals[i].wrappedName)")
                }
            }
            .disabled(selectedPerson == -1)
        }
    }
    
    func filteredGoals() -> [Goal] {
        guard selectedPerson != -1 else { return [] }
        
        return goals.filter { goal in
            return goal.peopleArray.contains(people[selectedPerson])
        }
    }
}

//struct GoalSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalSelectionView()
//    }
//}
