//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @State public var selectedPerson: Person? = nil
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HorizontalPeopleView(people: people, selectedPerson: $selectedPerson)
                        .padding(.bottom)
                    
                    if let selectedPerson = selectedPerson {
                        PersonDetailView(person: selectedPerson, geometry: geometry)
                    }
                }
            }
            .navigationTitle("People")
        }
    }
}

#Preview {
    PeopleView()
}
