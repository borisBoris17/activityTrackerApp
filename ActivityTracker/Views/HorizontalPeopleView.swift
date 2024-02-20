//
//  HorizontalPeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/02/2024.
//

import SwiftUI

struct HorizontalPeopleView: View {
    var people: FetchedResults<Person>
    @Binding var selectedPerson: Person?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(people) { person in
                    PersonButtonView(person: person, selectedPerson: $selectedPerson)
                }
            }
            .frame(height: 100)
        }
    }
}

//#Preview {
//    HorizontalPeopleView()
//}
