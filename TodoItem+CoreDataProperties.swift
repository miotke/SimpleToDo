//
//  TodoItem+CoreDataProperties.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var date: Date
    @NSManaged public var title: String
    @NSManaged public var details: String
    @NSManaged public var completed: Bool

}
