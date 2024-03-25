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
                .foregroundStyle(.brandColorDark)
            
            Text("\(Calendar.current.dateComponents([.day], from: day).day!)")
                .kerning(-2)
                .padding(.horizontal,Calendar.current.dateComponents([.day], from: day).day! > 9 ? 6 : 12)
                .foregroundStyle(isSelectedDay ? .brandColorLight : .brandColorDark)
                .font(.title)
                .background(isSelectedDay ? .brandColorDark : .clear, in: Circle())
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
    
    @State private var offset = CGSize.zero
    
    func getDay(daysToAdd: Int, from: Date) -> Date {
        Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: daysToAdd, to: from)!)
    }
    
    func isSameDay(first: Date, second: Date) -> Bool {
        Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
    }
    
    var body: some View {
        VStack {
            
            VStack {
                Text("\(Calendar.current.monthSymbols[startingSundayMonth - 1])")
                    .foregroundStyle(.brandColorDark)
                    .font(.footnote)
            }
            
            HStack {
                
                DateComponentView(day: startingSunday, dayOfWeek: "S", isSelectedDay: isSameDay(first: startingSunday, second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 1, from: startingSunday), dayOfWeek: "M", isSelectedDay: isSameDay(first: getDay(daysToAdd: 1, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 2, from: startingSunday), dayOfWeek: "T", isSelectedDay: isSameDay(first: getDay(daysToAdd: 2, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 3, from: startingSunday), dayOfWeek: "W", isSelectedDay: isSameDay(first: getDay(daysToAdd: 3, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 4, from: startingSunday), dayOfWeek: "T", isSelectedDay: isSameDay(first: getDay(daysToAdd: 4, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 5, from: startingSunday), dayOfWeek: "F", isSelectedDay: isSameDay(first: getDay(daysToAdd: 5, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
                
                Spacer()
                
                DateComponentView(day: getDay(daysToAdd: 6, from: startingSunday), dayOfWeek: "S", isSelectedDay: isSameDay(first: getDay(daysToAdd: 6, from: startingSunday), second: selectedDay), selectedDay: $selectedDay)
            }
            
            Divider()
                .background(.brandColorDark)
                .fontWeight(.bold)
            
            //            SeperatorView(height: 2, color: .brandColorDark)
        }
        .offset(x: offset.width)
        .padding(.bottom)
        //        .background(.neutral, in: RoundedRectangle(cornerRadius: 16))
        .highPriorityGesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { value in
                switch(value.translation.width, value.translation.height) {
                case (...0, -60...60):
                    startingSunday = Calendar.current.date(byAdding: .day, value: 7, to: startingSunday)!
                    
                    withAnimation {
                        offset = CGSize.zero
                    }
                case (0..., -60...60):
                    withAnimation {
                        offset = CGSize.zero
                    }
                    startingSunday = Calendar.current.date(byAdding: .day, value: -7, to: startingSunday)!
                    
                    withAnimation {
                        offset = CGSize.zero
                    }
                default:
                    
                    withAnimation {
                        offset = CGSize.zero
                    }
                    return
                }
            }
        )
    }
}

//#Preview {
//    HorizonalDateSelectView()
//}
