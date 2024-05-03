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
    @NSManaged public var endDate: Date?
    @NSManaged public var target: Int16
    @NSManaged public var progress: Double
    @NSManaged public var people: NSSet?
    
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
    
    public var wrappedEndDate: Date {
        endDate ?? Date()
    }
    
    public var activityArray: [Activity] {
        let set = activities as? Set<Activity> ?? []
        
        return set.sorted {
            $0.wrappedStartDate < $1.wrappedStartDate
        }
    }
    
    public var descendingActivityArray: [Activity] {
        let set = activityArray
        
        return set.reversed()
    }
    
    public var peopleArray: [Person] {
        let set = people as? Set<Person> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var formattedStartDate: String {
        startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    public var formattedEndDate: String {
        endDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    public var daysBetween: Int {
        Calendar.current.dateComponents([.day], from: Date.now, to: wrappedEndDate).day ?? 0
    }
    
    public var formattedProgress: String {
        String(format: "%.2f", progressInHours)
    }
    
    public var formattedHrsMinsProgress: String {
        let hoursInProgress = progressHours
        if hoursInProgress > 0 {
            let hoursLabel = hoursInProgress == 1 ? "hr" : "hrs"
            return "\(hoursInProgress) \(hoursLabel) \(progressMinutes) min"
        } else {
            return "\(progressMinutes) min"
        }
    }
    
    public var progressHours: Int {
        Int(Int(progress) / Int(minuteLength * hourLength))
    }
    
    public var progressMinutes: Int {
        Int((Int(progress) % Int(minuteLength * hourLength)) / Int(minuteLength))
    }
    
    public var progressInHours: CGFloat {
        progress / (Double(minuteLength * hourLength) )
    }
    
    public var percentageDone: CGFloat {
        CGFloat(Float(progressInHours) / Float(target))
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
    
    @objc(addPersonObject:)
    @NSManaged public func addToPerople(_ value: Person)
    
    @objc(removePersonObject:)
    @NSManaged public func removeFromPeople(_ value: Person)
    
    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)
    
    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)
    
}

extension Goal : Identifiable {
    
}
