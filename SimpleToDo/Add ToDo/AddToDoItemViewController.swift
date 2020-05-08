//
//  AddToDoItemViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        let dismissButtonImage = UIImage(systemName: "x.circle.fill")
        navigationItem.title = "Add item"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: dismissButtonImage, style: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
    }
    
    @objc func saveItem() {
        self.dismiss(animated: true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
