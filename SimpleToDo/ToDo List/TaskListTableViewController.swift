//
//  TaskListTableViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/13/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    enum reuseIdentifiers: String {
        case tableViewCell = "STTableViewCell"
        case toAddToDoItemVC = "toAddToDoItemVC"
    }
    
    var taskComplete = false
    var tasks: [TodoItem] = []
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        registerNib()
        connectPersistentContainer()
        loadSavedData()
    }
    
    private func setupNavigationController() {
        let addToDoItemButtonImage = UIImage(systemName: "plus")
        navigationItem.title = "Simple ToDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addToDoItemButtonImage, style: .plain, target: self, action: #selector(addToDoItem))
    }
    
    @objc func addToDoItem() {
        performSegue(withIdentifier: reuseIdentifiers.toAddToDoItemVC.rawValue, sender: self)
    }
    
    private func registerNib() {
        let STTableViewCell = UINib(nibName: "STTableViewCell", bundle: nil)
        tableView.register(STTableViewCell, forCellReuseIdentifier: reuseIdentifiers.tableViewCell.rawValue)
    }
    
    // MARK: Core Data stuff
    func connectPersistentContainer() {
        container = NSPersistentContainer(name: "SimpleToDo")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadSavedData() {
        let request = TodoItem.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            tasks = try container.viewContext.fetch(request)
            tableView.reloadData()
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
}
