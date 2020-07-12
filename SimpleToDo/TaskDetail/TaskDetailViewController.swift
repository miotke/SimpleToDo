//
//  TaskDetailViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 7/10/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    let dateLabel = SimpleLabel(fontSize: 18, fontWeight: .bold)
    let taskTitleLabel = UILabel()
    let taskCompleteButton = SimpleButton(title: "Complete task", backgroundColor: .systemBlue)
    
    var taskCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        layoutUI()
        configureButton()
    }
    
    private func configureButton() {
        taskCompleteButton.addTarget(self, action: #selector(completeTaskButtonTapped), for: .touchUpInside)
        switch taskCompleted {
        case true:
            taskCompleteButton.setTitle("Task is complete! 🍻", for: .normal)
            taskCompleteButton.backgroundColor = UIColor.systemGreen
        case false:
            return
        }
    }
    
    @objc func completeTaskButtonTapped() {
        switch taskCompleted {
        case true:
            dismiss(animated: true)
        case false:
            taskCompleteButton.setTitle("Task marked as complete! 🎉", for: .normal)
            taskCompleteButton.backgroundColor = UIColor.systemPurple
            delayViewDismissal()
        }
    }
    
    private func delayViewDismissal() {
//      This method delays the dismissal of the TaskDetailViewController so that the user
//      is able to see the change of the button. This gives the user verification that the
//      complete task change has been made. This happens on the main thread.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.dismiss(animated: true)
        }
    }
    
    private func setupNavigationController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func  layoutUI() {
        let taskDetailStackView = UIStackView(arrangedSubviews: [dateLabel, taskTitleLabel])
        let padding: CGFloat = 8
        
        taskDetailStackView.axis = .vertical
        taskDetailStackView.distribution = .equalSpacing
        view.addSubview(taskDetailStackView)
        taskDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(taskCompleteButton)
        taskCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskDetailStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            taskDetailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            taskDetailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            taskCompleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            taskCompleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            taskCompleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            taskCompleteButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
