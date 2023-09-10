//
//  Goal+CoreDataProperties.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 28/08/2023.
//
//

import Foundation
import CoreData


extension Goal {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var target: Int16
    @NSManaged public var progress: Int16
    @NSManaged public var person: Person?
    @NSManaged public var activities: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedDesc: String {
        desc ?? "Unknown Description"
    }
    
    public var wrappedStartDate: Date {
        startDate ?? Date()
    }
    
    public var activityArray: [Activity] {
        let set = activities as? Set<Activity> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var formattedStartDate: String {
        startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    public var percentageDone: CGFloat {
        CGFloat(Float(progress) / Float(target))
    }
}

// MARK: Generated accessors for activities
extension Goal {
    
    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)
    
    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)
    
    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)
    
    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)
    
}

extension Goal : Identifiable {
    
}
