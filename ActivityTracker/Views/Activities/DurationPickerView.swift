//
//  DurationPickerView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 04/04/2024.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    
    var body: some View {
        HStack {
            Picker("Hours", selection: $hours) {
                ForEach(0..<25) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.wheel)
            .frame(maxHeight: 150)
            .clipped()
            
            VStack {
                Spacer()
                Text("Hrs")
                Spacer()
            }
            .frame(maxHeight: 150)
            .clipped()
            
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.wheel)
            .frame(maxHeight: 150)
            .clipped()
            
            VStack {
                Spacer()
                Text("Min")
                Spacer()
            }
            .frame(maxHeight: 150)
            .clipped()
        }
    }
}

//#Preview {
//    DurationPickerView()
//}
