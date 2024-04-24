//
//  GoalSelectionView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/09/2023.
//

import SwiftUI


struct GoalSelectionView: View {
    @Binding var selectedGoals: Set<Goal>
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: false), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var goals: FetchedResults<Goal>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            List {
                ForEach(people) { person in
                    PersonSelectionRowView( selectedGoals: $selectedGoals, person: person, goals: goals)
                }
            }
    }
    
    struct PersonSelectionRowView: View {
        @Binding var selectedGoals: Set<Goal>
        var person: Person
        var goals: FetchedResults<Goal>
        
        @State private var isExpanded = true
        
        func filteredGoals(for person: Person) -> [Goal] {
            return goals.filter { goal in
                return goal.peopleArray.contains(person)
            }
        }
        
        var body: some View {
            HStack {
                Text(person.wrappedName)
                Spacer()
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    isExpanded ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                }
            }
            .onAppear() {
                for goal in filteredGoals(for: person) {
                    if selectedGoals.contains(goal) {
                        isExpanded = true
                        break
                    }
                }
            }
            
            if isExpanded {
                ForEach(filteredGoals(for: person)) { goal in
                    GoalSelectionRowView(goal: goal, selectedGoals: $selectedGoals)
                }
            }
        }
    }
    
    struct GoalSelectionRowView: View {
        var goal: Goal
        @Binding var selectedGoals: Set<Goal>
        
        @State private var isSelected = false
        
        func somethingk(goal: Goal) -> Bool {
            selectedGoals.contains(goal)
        }
        
        var body: some View {
            HStack {
                Text(goal.wrappedName)
                Spacer()
                Toggle(isOn: $isSelected) {
                    
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .accentColor(.primary)
                .onChange(of: isSelected) {
                    if isSelected && !selectedGoals.contains(goal) {
                        selectedGoals.insert(goal)
                    } else if !isSelected && selectedGoals.contains(goal) {
                        selectedGoals.remove(goal)
                    }
                }
            }
            .padding(.leading, 20)
            .onAppear() {
                isSelected = selectedGoals.contains(goal)
            }
        }
    }
    
    struct iOSCheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }, label: {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    configuration.label
                }
            })
        }
    }
}

//struct GoalSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalSelectionView()
//    }
//}
