//
//  Sorting.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 6/28/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import Foundation

class Sorting {
    
    let sortOnNotComplete = NSSortDescriptor(key: "taskCompleted", ascending: true)
    let sortOnCompleted = NSSortDescriptor(key: "taskCompleted", ascending: false)
    lazy var selectedSort = [sortOnNotComplete, sortOnCompleted]
    
    func sortCompleted() {
        selectedSort = [sortOnCompleted, sortOnNotComplete]
    }
    
    func sortNotCompleted() {
        selectedSort = [sortOnNotComplete, sortOnNotComplete]
    }
}
