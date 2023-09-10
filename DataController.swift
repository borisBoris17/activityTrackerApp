//
//  DataController.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 28/08/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "ActivityTracker")
    
    init() {
        container.loadPersistentStores { desctription, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
