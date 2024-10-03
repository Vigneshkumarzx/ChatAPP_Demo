//
//  Conversation+CoreDataProperties.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }
    @NSManaged public var id: UUID?
    @NSManaged public var lastMessage: String?
    @NSManaged public var participants: Set<User>?
}

// MARK: Generated accessors for participants
extension Conversation {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: User)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: User)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}

extension Conversation : Identifiable {

}
