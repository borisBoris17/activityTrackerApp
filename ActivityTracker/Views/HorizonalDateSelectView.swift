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
        }
    }
}

struct HorizonalDateSelectView: View {
    
    var startingSundayDay: Int
    var startingSundayMonth: Int
    var selectedDay: Int
    
//    var dayOfStartingSunday = Calendar.current.dateComponents([.day], from: startingSunday).day!
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                Text("\(Calendar.current.monthSymbols[startingSundayMonth - 1])")
                HStack {
                    Button {
                        print("clicked left")
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay, dayOfWeek: "S", isSelectedDay: startingSundayDay == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 1, dayOfWeek: "M", isSelectedDay: startingSundayDay + 1 == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 2, dayOfWeek: "T", isSelectedDay: startingSundayDay + 2 == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 3, dayOfWeek: "W", isSelectedDay: startingSundayDay + 3 == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 4, dayOfWeek: "T", isSelectedDay: startingSundayDay + 4 == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 5, dayOfWeek: "F", isSelectedDay: startingSundayDay + 5 == selectedDay)
                    
                    DateComponentView(circleSize: bounds.size.width * 0.1, day: startingSundayDay + 6, dayOfWeek: "S", isSelectedDay: startingSundayDay + 6 == selectedDay)
                    
                    Button {
                        print("clicked right")
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray)
                .opacity(0.5)
            }
//            .frame(maxHeight: 90)
        }
    }
}

//#Preview {
//    HorizonalDateSelectView()
//}
