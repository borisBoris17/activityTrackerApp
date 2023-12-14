//
//  Person+CoreDataProperties.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 28/08/2023.
//
//

import Foundation
import CoreData


extension Person: Comparable {
    public static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.wrappedName < rhs.wrappedName
    }
    
    public static let MAX_PEOPLE = 20
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var goals: NSSet?

    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedValue: String {
        wrappedName
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var goalsArray: [Goal] {
        let set = goals as? Set<Goal> ?? []
        
        return set.sorted {
            $0.wrappedStartDate < $1.wrappedStartDate
        }
    }
}

// MARK: Generated accessors for goals
extension Person {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: Goal)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: Goal)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}

extension Person : Identifiable {

}
