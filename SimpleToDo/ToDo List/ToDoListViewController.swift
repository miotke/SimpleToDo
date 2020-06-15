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
    fileprivate let request = Task.createFetchRequest()
    var sortOnNotComplete = NSSortDescriptor(key: "taskCompleted", ascending: true)
    var sortOnCompleted = NSSortDescriptor(key: "taskCompleted", ascending: false)
    lazy var selectedSort = [sortOnNotComplete, sortOnCompleted]
    
    lazy var appDelegateContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var container = NSPersistentContainer(name: "SimpleToDo")
    var datasource: UITableViewDiffableDataSource<Section, Task>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let sortingButtonImage = UIImage(systemName: "slider.horizontal.3")
        
        navigationItem.title = "Simple ToDo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: sortingButtonImage, style: .plain, target: self, action: #selector(selectSortingType))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addTaskItemButtonImage, style: .plain, target: self, action: #selector(addTaskItemButton))
    }
    
    @objc func selectSortingType() {
        let alertActionSheet = UIAlertController(title: "Sort by:", message: "Choose how you want to sort tasks", preferredStyle: .actionSheet)
        
        alertActionSheet.addAction(UIAlertAction(title: "Completed", style: .default, handler: { action in
            self.selectedSort = [self.sortOnCompleted, self.sortOnNotComplete]
            self.fetchSavedData()
        }))
        
        alertActionSheet.addAction(UIAlertAction(title: "Not completed", style: .default, handler: { action in
            self.selectedSort = [self.sortOnNotComplete, self.sortOnNotComplete]
            self.fetchSavedData()
        }))
        
        alertActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertActionSheet, animated: true, completion: nil)
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
        request.sortDescriptors = selectedSort
        
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
            self.fetchSavedData()
        }
    }

}

extension ToDoListViewController {
    enum Section {
        case main
    }
}
