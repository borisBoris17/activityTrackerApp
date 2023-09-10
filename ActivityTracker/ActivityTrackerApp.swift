//
//  ActivityTrackerApp.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

@main
struct ActivityTrackerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
