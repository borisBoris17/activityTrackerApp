//
//  SeperatorView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI

struct SeperatorView: View {
    var height: CGFloat
    var color: Color
    
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(color)
            .padding(.vertical)
    }
}

struct SeperatorView_Previews: PreviewProvider {
    static var previews: some View {
        SeperatorView(height: 2, color: .secondary)
    }
}
