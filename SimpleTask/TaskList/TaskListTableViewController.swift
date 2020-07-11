//
//  TaskListTableViewController.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    enum reuseIdentifiers: String {
        case tableViewCell = "STTableViewCell"
        case toAddTaskViewController = "toAddTaskViewController"
        case toTaskDetailViewController = "toTaskDetailViewController"
    }
    
    var taskComplete = false
    let dateFormatter = DateFormatter()
    fileprivate let request = Task.createFetchRequest()
    let sorting = Sorting()
    
    var tasks: [Task] = []
    
    lazy var appDelegateContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var container = NSPersistentContainer(name: "SimpleToDo")
    var datasource: UITableViewDiffableDataSource<Section, Task>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(STTableViewCell.self, forCellReuseIdentifier: STTableViewCell.reuseId)

        setupNavigationController()
        setupCoreData()
        fetchSavedData()
        configureDataSource()
        setupSnapshot()
        updateSnapshotWhenSaving()
    }
    
    private func setupNavigationController() {
        let addTaskItemButtonImage = UIImage(systemName: "plus")
        let sortingButtonImage = UIImage(systemName: "slider.horizontal.3")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: sortingButtonImage, style: .plain, target: self, action: #selector(selectSortingType))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addTaskItemButtonImage, style: .plain, target: self, action: #selector(addTaskItemButton))
    }
    
    @objc func selectSortingType() {
        let alertActionSheet = UIAlertController(title: "Sort by:", message: "Choose how you want to sort tasks", preferredStyle: .actionSheet)
        
        alertActionSheet.addAction(UIAlertAction(title: "Completed", style: .default, handler: { action in
            self.sorting.sortCompleted()
            self.fetchSavedData()
        }))
        
        alertActionSheet.addAction(UIAlertAction(title: "Not completed", style: .default, handler: { action in
            self.sorting.sortNotCompleted()
            self.fetchSavedData()
        }))
        
        alertActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertActionSheet, animated: true, completion: nil)
    }
    
    @objc func addTaskItemButton() {
        let addTaskListViewController = AddTaskItemViewController()
        let navigationController = UINavigationController(rootViewController: addTaskListViewController)
        
        present(navigationController, animated: true)
    }
    
    // MARK: - CoreData
    func setupCoreData() {
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error {
                print("❌ failed to load database \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSavedData() {
        request.sortDescriptors = sorting.selectedSort
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            setupSnapshot()
            tasks.append(contentsOf: fetchedResultsController.fetchedObjects!)
        } catch {
            print("❌ Fetch failed \(error.localizedDescription)")
        }
    }
    
    // MARK: - Diffable data source and table view set up
    func setupSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        datasource?.apply(snapshot)
    }
        
    func configureDataSource() {
        datasource = UITableViewDiffableDataSource<Section, Task>(tableView: tableView) { ( tableView, indexPath, task) -> UITableViewCell in
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

            guard let cell = tableView.dequeueReusableCell(withIdentifier: STTableViewCell.reuseId, for: indexPath) as? STTableViewCell else {
                fatalError()
            }
            
            self.dateFormatter.dateStyle = .short
            
            cell.taskTitleTextLabel.text = task.title
            
            switch task.taskCompleted {
            case true:
                cell.taskDateLabel.text = "Date completed: \(self.dateFormatter.string(from: task.date))"
                cell.taskStatusIndicatorImageView.image = UIImage(systemName: "checkmark.circle")
                cell.taskStatusIndicatorImageView.tintColor = .systemGreen
            case false:
                cell.backgroundColor = .systemRed
                cell.taskDateLabel.text = "Not complete"
                cell.taskStatusIndicatorImageView.image = UIImage(systemName: "x.circle")
                cell.taskStatusIndicatorImageView.tintColor = .systemBackground
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        let taskDetailViewController = TaskDetailViewController()
        
        let navigationController = UINavigationController(rootViewController: taskDetailViewController)
        
        taskDetailViewController.navigationItem.title = selectedTask.title
        taskDetailViewController.dateLabel.text = "Date completed: \(self.dateFormatter.string(from: selectedTask.date))"
        taskDetailViewController.taskTitleLabel.text = selectedTask.title
        
        present(navigationController, animated: true)
    }
    
    private func updateSnapshotWhenSaving() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateSnapshot"), object: nil, queue: nil) { (_) in
            self.fetchSavedData()
        }
    }
}

extension TaskListTableViewController {
    enum Section {
        case main
    }
}
