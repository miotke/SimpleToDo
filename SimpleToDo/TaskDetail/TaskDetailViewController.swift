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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        layoutUI()
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
