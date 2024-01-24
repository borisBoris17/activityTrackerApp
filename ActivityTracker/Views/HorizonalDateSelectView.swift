//
//  HorizonalDateSelectView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 20/12/2023.
//

import SwiftUI

struct DateComponentView: View {
    var day: Date
    var dayOfWeek: String
    var isSelectedDay: Bool
    @Binding var selectedDay: Date
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .fontWeight(.bold)
            ZStack {
                Circle()
                    .fill(isSelectedDay ? .blue : .clear)
                Text("\(Calendar.current.dateComponents([.day], from: day).day!)")
            }
        }
        .onTapGesture {
            selectedDay = day
        }
    }
}

struct HorizonalDateSelectView: View {
    
    @Binding var startingSunday: Date
    var startingSundayDay: Int
    var startingSundayMonth: Int
    @Binding var selectedDay: Date
    
    func getDay(daysToAdd: Int, from: Date) -> Date {
        Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: daysToAdd, to: from)!)
    }
    
    func isSameDay(first: Date, second: Date) -> Bool {
        Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
    }
    
    var body: some View {
        ZStack {                
            RoundedRectangle(cornerRadius: 16)
                .opacity(0.5)
            
            VStack {
                Text("\(Calendar.current.monthSymbols[startingSundayMonth - 1])")
                    .offset(y: -10)
                HStack {
                    Button {
                        withAnimation {
                            startingSunday = Calendar.current.date(byAdding: .day, value: -7, to: startingSunday)!
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    
                    DateComponentView(day: startingSunday, dayOfWeek: "S", isSelectedDay: isSameDay(first: startingSunday, second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 1, from: startingSunday), dayOfWeek: "M", isSelectedDay: isSameDay(first: getDay(daysToAdd: 1, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 2, from: startingSunday), dayOfWeek: "T", isSelectedDay: isSameDay(first: getDay(daysToAdd: 2, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 3, from: startingSunday), dayOfWeek: "W", isSelectedDay: isSameDay(first: getDay(daysToAdd: 3, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 4, from: startingSunday), dayOfWeek: "T", isSelectedDay: isSameDay(first: getDay(daysToAdd: 4, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 5, from: startingSunday), dayOfWeek: "F", isSelectedDay: isSameDay(first: getDay(daysToAdd: 5, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    DateComponentView(day: getDay(daysToAdd: 6, from: startingSunday), dayOfWeek: "S", isSelectedDay: isSameDay(first: getDay(daysToAdd: 6, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                    
                    Button {
                        startingSunday = Calendar.current.date(byAdding: .day, value: 7, to: startingSunday)!
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

//#Preview {
//    HorizonalDateSelectView()
//}
