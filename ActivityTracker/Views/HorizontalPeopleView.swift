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
    var imageHasChanged: Bool
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(people) { person in
                        PersonButtonView(person: person, selectedPerson: $selectedPerson, imageHasChanged: imageHasChanged)
                    }
                }
            }
        }
    }
}

//#Preview {
//    HorizontalPeopleView()
//}
