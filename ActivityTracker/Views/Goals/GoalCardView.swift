//
//  GoalCardView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/03/2024.
//

import SwiftUI

struct GoalCardView: View {
    var goal: Goal
    var showPerson: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if (showPerson) {
                Text(goal.peopleArray[0].wrappedName)
                    .lineLimit(1)
                    .font(.footnote)
            }
            
            
            Text("\(goal.wrappedName)")
                .font(.title)
            Text("\(goal.wrappedDesc)")
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("\(goal.formattedProgress)/\(goal.target)")
            }
        }
        .foregroundStyle(.brandText)
        .padding()
        .frame(width: 175, height: 175)
        .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    GoalCardView()
//}
