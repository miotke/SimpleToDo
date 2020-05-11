//
//  AddToDoItemViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {
    
    var dateOfTask: String = "qqeqwewqe"
    let dateLabel = UILabel()
    let taskTitleTextField = UITextField()
    let taskCompleteSwitch = UISwitch()
    let taskCompleteLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatDate()
        setupNavigationController()
        addSubviews()
        configureUI()
        configureStaticUI()
    }
    
    private func setupNavigationController() {
        let dismissButtonImage = UIImage(systemName: "x.circle.fill")
        navigationItem.title = "Add task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: dismissButtonImage, style: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
    }
    
    @objc func saveItem() {
        self.dismiss(animated: true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func configureStaticUI() {
        // Placeholder method. Eventually the following strings will be moved to an initilizer
        taskCompleteLabel.text = "Task complete: "
        taskTitleTextField.placeholder = "Task title"
        dateLabel.text = "Date of task: \(self.dateOfTask)"
    }
    
    func formatDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return self.dateOfTask = dateFormatter.string(from: date)
    }
    
    private func addSubviews() {
        view.addSubview(dateLabel)
        view.addSubview(taskTitleTextField)
        view.addSubview(taskCompleteSwitch)
        view.addSubview(taskCompleteLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        taskCompleteSwitch.translatesAutoresizingMaskIntoConstraints = false
        taskCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureUI() {
        let taskCompleteStackView = UIStackView(arrangedSubviews: [taskCompleteLabel, taskCompleteSwitch])
        taskCompleteStackView.axis = .horizontal
        view.addSubview(taskCompleteStackView)
        taskCompleteStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let taskDetailsStackView = UIStackView(arrangedSubviews: [dateLabel, taskTitleTextField, taskCompleteStackView])
        taskDetailsStackView.axis = .vertical
        view.addSubview(taskDetailsStackView)
        taskDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskDetailsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskDetailsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
