//
//  ActivityTrackerApp.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

class RefreshData: ObservableObject {
    @Published var goalRefreshId = UUID()
    @Published var activityRefreshId = UUID()
}


@main
struct ActivityTrackerApp: App {
    @StateObject private var dataController = DataController()
    
    let refreshData = RefreshData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(refreshData)
        }
    }
}
