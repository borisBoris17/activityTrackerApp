//
//  ContentView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            
            ActivitiesView()
                .tabItem {
                    Label("Activities", systemImage: "timer")
                }
                .tag(2)

            
            Text("Calendar")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(3)

        }
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
