//
//  TaskDetailViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 6/15/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var taskDetail: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "Task: \(taskDetail?.title)"
        
    }
}
