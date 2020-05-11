//
//  AddToDoItemViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit
import CoreData

class AddToDoItemViewController: UIViewController {
    
    var dateOfTask: String = ""
    let dateLabel = UILabel()
    let taskTitleTextField = UITextField()
    let taskCompleteSwitch = UISwitch()
    let taskCompleteLabel = UILabel()
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        formatDate()
        loadPersistentContainer()
        setupNavigationController()
        addSubviews()
        configureUI()
        configureStaticUI()
    }
    
    func loadPersistentContainer() {
        container = NSPersistentContainer(name: "SimpleToDo")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveTask() {
        let task = TodoItem(context: container.viewContext)
        let formatter = DateFormatter()
        
        task.title = self.taskTitleTextField.text!
        task.date = formatter.date(from: "MMM d, yyyy") ?? Date()
        task.taskCompleted = taskCompleteSwitch.isOn
        
        self.saveContext()
        print(task.date)
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("🚨 error \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNavigationController() {
        let dismissButtonImage = UIImage(systemName: "x.circle.fill")
        navigationItem.title = "Add task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: dismissButtonImage, style: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
    }
    
    @objc func saveItem() {
        saveTask()
        self.dismiss(animated: true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func configureStaticUI() {
        // Placeholder method. Eventually the following strings will be moved to an initilizer
        taskCompleteLabel.text = "Task complete: "
        taskTitleTextField.placeholder = "Task"
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
        
        let taskDetailsStackView = UIStackView(arrangedSubviews: [taskTitleTextField, dateLabel, taskCompleteStackView])
        taskDetailsStackView.axis = .vertical
        taskDetailsStackView.distribution = .fillEqually
        taskDetailsStackView.spacing = 5
        view.addSubview(taskDetailsStackView)
        taskDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskDetailsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskDetailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskDetailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
}
