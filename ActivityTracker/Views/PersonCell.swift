//
//  PersonCell.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 11/12/2023.
//

import SwiftUI

struct PersonCell: View {
    
    let person: Person
    
    var body: some View {
        Text("\(person.wrappedName)")
    }
}

//#Preview {
//    PersonCell()
//}
