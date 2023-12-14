//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI

enum ActivityStatus {
    case ready, started, paused, stoped
}

struct ActivityView: View {
    
    @State private var name = ""
    @State private var desc = ""
    @State private var selectedPerson = -1
    @State private var selectedGoal = -1
    @State private var numberOfGoals = 1
    

    
    
    var body: some View {
        VStack {
            
        }
        .padding(.top)
    }
    
    func disableTimer() -> Bool {
        name == "" || desc == "" || selectedPerson == -1
    }
    
    
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
