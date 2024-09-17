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
            .padding(5)
            .background(.brand, in: Circle())
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .labelStyle(.iconOnly)
            .padding()
            .shadow(color: .brandColorLight, radius: 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
