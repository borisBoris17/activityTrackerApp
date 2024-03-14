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
            .background(.brand, in: Circle())
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .labelStyle(.iconOnly)
            .padding()
            .shadow(color: .brandColorLight, radius: 5)
    }
}
