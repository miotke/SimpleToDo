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
        case toAddTaskViewController = "toAddTaskViewController"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskComplete = false
    let dateFormatter = DateFormatter()
    
    lazy var appDelegateContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var container = NSPersistentContainer(name: "SimpleToDo")
    var datasource: UITableViewDiffableDataSource<Section, Task>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        
        setupNavigationController()
        registerNib()
        setupCoreData()
        fetchSavedData()
        configureDataSource()
        setupSnapshot()
        updateSnapshotWhenSaving()
    }
    
    private func setupNavigationController() {
        let addTaskItemButtonImage = UIImage(systemName: "plus")
        navigationItem.title = "Simple ToDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addTaskItemButtonImage, style: .plain, target: self, action: #selector(addTaskItemButton))
    }
    
    @objc func addTaskItemButton() {
        performSegue(withIdentifier: reuseIdentifiers.toAddTaskViewController.rawValue, sender: self)
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
        let request = Task.createFetchRequest()
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
        snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        datasource?.apply(snapshot)
    }
        
    func configureDataSource() {
        datasource = UITableViewDiffableDataSource<Section, Task>(tableView: tableView) { ( tableView, indePath, task) -> UITableViewCell in
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.tableViewCell.rawValue, for: indePath) as? STTableViewCell else {
                fatalError()
            }
            
            self.dateFormatter.dateStyle = .short
            
            cell.taskTitleTextLabel.text = task.title
            switch task.taskCompleted {
            case true:
                cell.taskDateLabel.text = "Date completed: \(self.dateFormatter.string(from: task.date))"
                cell.taskItemStatusIndictorImage.image = UIImage(systemName: "checkmark.circle")
                cell.taskItemStatusIndictorImage.tintColor = .systemGreen
            case false:
                cell.backgroundColor = .systemRed
                cell.taskDateLabel.text = "Not complete"
                cell.taskItemStatusIndictorImage.image = UIImage(systemName: "x.circle")
                cell.taskItemStatusIndictorImage.tintColor = .systemBackground
            }
            
            return cell
        }
    }
    
    private func updateSnapshotWhenSaving() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateSnapshot"), object: nil, queue: nil) { (_) in
            print("do something👻")
            self.fetchSavedData()
        }
    }

}

extension ToDoListViewController {
    enum Section {
        case main
    }
}
