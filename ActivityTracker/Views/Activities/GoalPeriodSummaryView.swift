//
//  GoalPeriodSummaryView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 20/09/2024.
//

import SwiftUI

struct GoalPeriodSummaryView: View {
    var goal: Goal
    var periodTotal: Int32
    
    func formattedHrsMinsDuration(duration: Int32) -> String {
        let hoursInDuration = Int(duration / Int32(minuteLength * hourLength))
        let minutesInDuration = Int((duration % Int32(minuteLength * hourLength)) / Int32(minuteLength))
        if hoursInDuration > 0 {
            let hoursLabel = hoursInDuration == 1 ? "hr" : "hrs"
            return "\(hoursInDuration) \(hoursLabel) \(minutesInDuration) min"
        } else {
            return "\(minutesInDuration) min"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(goal.wrappedName)
                    .font(.headline)
                    .foregroundColor(.brandText)
                    .lineLimit(1)
                    .frame(maxWidth: 150, alignment: .leading)
                
                Spacer()
            }
            
            HStack {
                Text(goal.peopleArray[0].wrappedName)
                    .foregroundColor(.brandMediumLight)
                    .lineLimit(1)
                    .frame(maxWidth: 150, alignment: .leading)
                
                Spacer()
            }
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Text("\(formattedHrsMinsDuration(duration: periodTotal))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.brandText)
            }
            .padding(.leading)
        }
        .padding()
        .background(.brandBackground.opacity(0.6), in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    GoalPeriodSummaryView()
//}
