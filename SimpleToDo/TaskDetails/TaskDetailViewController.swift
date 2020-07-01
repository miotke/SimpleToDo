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
    
    var aTitle = ""
    
    var taskDetail: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        testLabel.text = "Task: \(aTitle)"
        
    }
    
    func setupNavigationController() {
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "x.circle.fill"), style: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true)
    }
}
