//
//  ViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    enum reuseIdentifiers: String {
        case tableViewCell = "STTableViewCell"
        case toAddToDoItemVC = "toAddToDoItemVC"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskComplete = false
//    var tasks: [TodoItem] = []
    
    lazy var appDelegateContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var container = NSPersistentContainer(name: "SimpleToDo")
    var datasource: UITableViewDiffableDataSource<Section, TodoItem>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, TodoItem>()
    var fetchedResultsController: NSFetchedResultsController<TodoItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
//        tableView.dataSource = self
        
        setupNavigationController()
        registerNib()
        setupCoreData()
        fetchSavedData()
        configureDataSource()
        setupSnapshot()
        
//        connectPersistentContainer()
//        loadSavedData()
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
    
    // MARK: - Core Data stuff
    func setupCoreData() {
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error {
                print("❌ failed to load database \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSavedData() {
        let request = TodoItem.createFetchRequest()
        let sort = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            setupSnapshot()
        } catch {
            print("❌ Fetch failed \(error.localizedDescription)")
        }
    }
    
    func setupSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, TodoItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        datasource?.apply(snapshot)
    }
    
    func configureDataSource() {
        datasource = UITableViewDiffableDataSource<Section, TodoItem>(tableView: tableView) { ( tableView, indePath, task) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.tableViewCell.rawValue, for: indePath) as? STTableViewCell else {
                fatalError()
            }
            
            cell.todoListTextLabel.text = task.title
            switch task.taskCompleted {
            case true:
                cell.todoItemStatus.image = UIImage(systemName: "checkmark.circle")
            case false:
                cell.todoItemStatus.image = UIImage(systemName: "x.circle")
            }
            
            return cell
        }
    }
    
    private func updateSnapshotWhenSaving() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateSnapshot"), object: nil, queue: nil) { (_) in
            self.setupSnapshot()
        }
    }
}

// MARK: Extension - Table View
extension ToDoListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.tableViewCell.rawValue, for: indexPath) as? STTableViewCell
//        let task = tasks[indexPath.row]
//
//        cell?.todoListTextLabel.text = task.title
//        switch task.taskCompleted {
//        case true:
//            cell?.todoItemStatus.image = UIImage(systemName: "checkmark.circle")
//        case false:
//            cell?.todoItemStatus.image = UIImage(systemName: "x.circle")
//        }
//
//        return cell!
//    }
}

extension ToDoListViewController {
    enum Section {
        case main
    }
}
