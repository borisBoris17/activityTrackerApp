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
    @NSManaged public var duration: Int32
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
        let durationInHours = Double(duration) / (Double(minuteLength) * Double(hourLength))
        return String(format: "%.2f", durationInHours)
    }
    
    public var formattedHrsMinsDuration: String {
        let hoursInDuration = durationHours
        if hoursInDuration > 0 {
            let hoursLabel = hoursInDuration == 1 ? "hr" : "hrs"
            return "\(durationHours) \(hoursLabel) \(durationMinutes) min"
        } else {
            return "\(durationMinutes) min"
        }
    }
    
    public var durationHours: Int {
        Int(duration / Int32(minuteLength * hourLength))
    }
    
    public var durationMinutes: Int {
        Int((duration % Int32(minuteLength * hourLength)) / Int32(minuteLength))
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
