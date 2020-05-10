//
//  AddToDoItemViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {
    
    let taskTitleTextField = UITextField()
    let taskDetailsTextView = UITextView()
    let taskCompleteSwitch = UISwitch()
    let taskCompleteLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        addSubviews()
        configureUI()
        
        taskCompleteLabel.text = "Task complete: "
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
    
    func addSubviews() {
        view.addSubview(taskTitleTextField)
        view.addSubview(taskDetailsTextView)
        view.addSubview(taskCompleteSwitch)
        view.addSubview(taskCompleteLabel)
        
        taskTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        taskCompleteSwitch.translatesAutoresizingMaskIntoConstraints = false
        taskCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureUI() {
        let taskCompleteStackView = UIStackView(arrangedSubviews: [taskCompleteLabel, taskCompleteSwitch])
        taskCompleteStackView.axis = .horizontal
        
        view.addSubview(taskCompleteStackView)
        taskCompleteStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskCompleteStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskCompleteStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
}
