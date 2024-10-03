//
//  Message+CoreDataProperties.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var senderId: UUID?
    @NSManaged public var isRead: Bool
    @NSManaged public var isSentByCurrentUser: Bool
    @NSManaged public var conversation: Conversation?

}

extension Message : Identifiable {

}
