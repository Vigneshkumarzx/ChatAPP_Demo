//
//  User+CoreDataProperties.swift
//  ChatAPP_Demo
//
//  Created by vignesh kumar c on 02/10/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var avatar: String?

}

extension User : Identifiable {

}
