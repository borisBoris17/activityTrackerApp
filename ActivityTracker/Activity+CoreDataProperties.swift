//
//  Activity+CoreDataProperties.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 28/08/2023.
//
//

import Foundation
import CoreData


extension Activity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var duration: Int16
    @NSManaged public var goals: NSSet?
    @NSManaged public var startDate: Date?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedDesc: String {
        desc ?? "Unknown Description"
    }
    
    public var formattedDuration: String {
        var durationInHours = Double(duration) / (Double(minuteLength) * Double(hourLength))
        return String(format: "%.2f", durationInHours)
    }
    
    public var goalArray: [Goal] {
        let set = goals as? Set<Goal> ?? []
        
        return set.sorted {
            $0.wrappedStartDate < $1.wrappedStartDate
        }
    }
    
    public var wrappedStartDate: Date {
        startDate ?? Date.now
    }
    
    public var formattedStartDate: String {
        startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }

}

// MARK: Generated accessors for goals
extension Activity {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: Goal)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: Goal)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}

extension Activity : Identifiable {

}
