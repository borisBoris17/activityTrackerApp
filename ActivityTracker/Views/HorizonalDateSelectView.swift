//
//  HorizonalDateSelectView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 20/12/2023.
//

import SwiftUI

struct DateComponentView: View {
    var circleSize: CGFloat
    var day: Int
    var dayOfWeek: String
    var isSelectedDay: Bool
    @Binding var selectedDay: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .fontWeight(.bold)
            ZStack {
                Circle()
                    .fill(isSelectedDay ? .blue : .clear)
                    .frame(width: circleSize, height: circleSize)
                Text("\(day)")
            }
            .onTapGesture {
                selectedDay = day
            }
        }
    }
}

struct HorizonalDateSelectView: View {
    
    @Binding var startingSunday: Date
    var startingSundayDay: Int
    var startingSundayMonth: Int
    @Binding var selectedDay: Int
    
//    var dayOfStartingSunday = Calendar.current.dateComponents([.day], from: startingSunday).day!
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                Text("\(Calendar.current.monthSymbols[startingSundayMonth - 1])")
                    .offset(y: -10)
                HStack {
                    Button {
                        startingSunday = Calendar.current.date(byAdding: .day, value: -7, to: startingSunday)!
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay, dayOfWeek: "S", isSelectedDay: startingSundayDay == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 1, dayOfWeek: "M", isSelectedDay: startingSundayDay + 1 == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 2, dayOfWeek: "T", isSelectedDay: startingSundayDay + 2 == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 3, dayOfWeek: "W", isSelectedDay: startingSundayDay + 3 == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 4, dayOfWeek: "T", isSelectedDay: startingSundayDay + 4 == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 5, dayOfWeek: "F", isSelectedDay: startingSundayDay + 5 == selectedDay, selectedDay: $selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 6, dayOfWeek: "S", isSelectedDay: startingSundayDay + 6 == selectedDay, selectedDay: $selectedDay)
                    
                    Button {
                        startingSunday = Calendar.current.date(byAdding: .day, value: 7, to: startingSunday)!
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray)
            .opacity(0.5)
        }
    }
}

//#Preview {
//    HorizonalDateSelectView()
//}
