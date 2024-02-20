//
//  ButtonStyles.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
//            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding()
    }
}
