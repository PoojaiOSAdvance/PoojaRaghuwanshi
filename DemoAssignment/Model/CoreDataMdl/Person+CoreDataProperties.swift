//
//  Person+CoreDataProperties.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var userName: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var confrimPassword: String

}

extension Person : Identifiable {

}
