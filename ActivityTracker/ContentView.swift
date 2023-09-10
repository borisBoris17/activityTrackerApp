//
//  ContentView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Text("Calendar")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
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
