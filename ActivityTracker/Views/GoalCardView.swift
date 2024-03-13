//
//  GoalCardView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/03/2024.
//

import SwiftUI

struct GoalCardView: View {
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(goal.wrappedName)")
                .font(.title)
            Text("\(goal.wrappedDesc)")
//            Text("\(goal.wrappedName)")
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("\(goal.formattedProgress)/\(goal.target)")
            }
        }
        .padding()
        .frame(width: 165, height: 165)
        .background(.secondary, in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    GoalCardView()
//}
