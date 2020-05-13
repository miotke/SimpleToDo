//
//  TaskListTableViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/13/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    enum reuseIdentifiers: String {
        case tableViewCell = "STTableViewCell"
        case toAddToDoItemVC = "toAddToDoItemVC"
    }
    
    var taskComplete = false
    var tasks: [TodoItem] = []

    var container = NSPersistentContainer(name: "SimpleToDo")
    var fetchedResultsController: NSFetchedResultsController<TodoItem>!
    var diffableDataSource: UITableViewDiffableDataSource<Int, TodoItem>?
    var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupFetchedResultsController()
        setupCoreData()
        registerNib()
        loadSavedData()
        setupTableView()
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
            try fetchedResultsController.performFetch()
            setupSnapshot()
            print("loadSavedData \(tasks.count)")
            
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func setupCoreData() {
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Failed to load database: \(error.localizedDescription)")
            }
        }
    }
    
    func setupFetchedResultsController() {
        let request = TodoItem.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)

        request.fetchBatchSize = tasks.count
        request.sortDescriptors = [sort]

        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            setupSnapshot()
            print("setupFetchedResultsController \(tasks.count)")
        } catch {
            print("Fetch failed \(error.localizedDescription)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
    
    private func setupTableView() {
        diffableDataSource = UITableViewDiffableDataSource<Int, TodoItem>(tableView: tableView) { (tableView, indexPath, task) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.tableViewCell.rawValue, for: indexPath) as? STTableViewCell
            
            cell?.todoListTextLabel.text = task.title
            switch task.taskCompleted {
            case true:
                cell?.todoItemStatus.image = UIImage(systemName: "checkmark.circle")
            case false:
                cell?.todoItemStatus.image = UIImage(systemName: "x.circle")
            }
            
            return cell
        }
        
        setupSnapshot()
    }
    
    private func setupSnapshot() {
        diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        diffableDataSource?.apply(self.diffableDataSourceSnapshot)
    }
    
    func updateSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        diffableDataSource?.apply(self.diffableDataSourceSnapshot)
    }
}
