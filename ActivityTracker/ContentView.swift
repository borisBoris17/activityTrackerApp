//
//  ContentView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 2
    @State private var presentedGoals: [Goal] = []
    @State private var goalsPath = NavigationPath()
    @State private var activitiesPath = NavigationPath()
    @State private var peoplePath = NavigationPath()
    
    private func tabSelection() -> Binding<Int> {
        Binding {
         self.selection
        } set: { tappedTab in
         if tappedTab == self.selection {
             if tappedTab == 1 {
                 goalsPath = NavigationPath()
             } else if tappedTab == 2 {
                 activitiesPath = NavigationPath()
             } else {
                 peoplePath = NavigationPath()
             }
         }
         self.selection = tappedTab
        }
     }
    
    var body: some View {
        TabView(selection: tabSelection()) {
            GoalsView(path: $goalsPath, selection: tabSelection())
                .tabItem {
                    Label("Goals", systemImage: "list.clipboard")
                }
                .tag(1)
            
            ActivitiesView(path: $activitiesPath, selection: tabSelection())
                .tabItem {
                    Label("Activities", systemImage: "timer")
                }
                .tag(2)
            
            PeopleView(path: $peoplePath)
                .tabItem {
                    Label("People", systemImage: "person.3")
                }
                .tag(3)
            
        }
        .accentColor(.brand)
        .onAppear {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
