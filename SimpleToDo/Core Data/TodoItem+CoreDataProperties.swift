//
//  TodoItem+CoreDataProperties.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/11/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date
    @NSManaged public var details: String?
    @NSManaged public var taskCompleted: Bool
    @NSManaged public var title: String

}
