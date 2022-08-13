//
//  ViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/6/26.
//

import UIKit
import CoreData

enum Section {
    case all
}

class EntryListViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Property
    var path = NSHomeDirectory()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Entry]?
    lazy var dataSource = configureDataSource()
    
    private var tableView: UITableView = UITableView()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntries()
        
        view.addSubview(tableView)
        
        setupNavigationBar()
        
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEntries()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        print(appFolder)
    }
    
    // MARK: - ViewSetup
    
    func setupNavigationBar() {
        title = "Home"
        navigationItem.largeTitleDisplayMode                    = .always
        navigationController?.navigationBar.prefersLargeTitles  = true
        navigationController?.navigationBar.isTranslucent       = true
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntry))
        let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(EntryListViewController.addEntry))
        
        self.navigationItem.leftBarButtonItem   = editButton
        self.navigationItem.rightBarButtonItem  = addButton
    }

    
    func setupLayout() {
        tableView.frame = UIScreen.main.bounds
        tableView.separatorStyle = .singleLine
    }
    
    // MARK: - Private

    func fetchEntries() {
        do {
            self.items = try self.context.fetch(Entry.fetchRequest())
            DispatchQueue.main.async {
                var snapshot = NSDiffableDataSourceSnapshot<Section, Entry>()
                snapshot.appendSections([.all])
                snapshot.appendItems(self.items!, toSection: .all)
                self.dataSource.apply(snapshot)
            }
        } catch {
            print("Getting entries failed...")
        }
    }
    
    @objc func addEntry() {
        let alert = UIAlertController(title: "New note", message: "Adding a new note", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Save note", style: .default) { (action) in
            let textfield = alert.textFields![0]
            
            // Create a Entry object
            let newEntry = Entry(context: self.context)
            newEntry.id = UUID()
            newEntry.content = textfield.text
            newEntry.createdAt = Date()
            newEntry.updatedAt = newEntry.createdAt
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Save notes error...")
            }
            
            // Re-fetch the data
            self.fetchEntries()
        }
        
        // Add button
        alert.addAction(submitButton)
        
        // Showing alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editEntry() {
        
    }
    
    @objc func remove(_ entry: Entry) {
        self.context.delete(entry)
        
        // Save context
        do {
            try self.context.save()
        } catch {
            print("Save context failed...")
        }
        
        // Re-fetch data
        self.fetchEntries()
    }
    
    func viewDetail(of entry: Entry) {
        let viewController = EntryDetailsViewController()
        viewController.entry = entry
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Data source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Entry> {
        let dataSource = UITableViewDiffableDataSource<Section, Entry>(tableView: tableView, cellProvider: {tableView, indexPath, entry in
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            cell.createdAtLabel.text    = dateFormatter.string(from: entry.createdAt!)
            cell.contentLabel.text      = entry.content

            var count = 0
            if entry.replies != nil {
                count = entry.replies!.count
            }
            cell.repliesCountLabel.text = "\(count)"
            return cell
        })
        return dataSource
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, view, completionhandler) in
            let entry = self?.items![indexPath.row]
            self?.remove(entry!)
            completionhandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.items?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items![indexPath.row]
        viewDetail(of: item)
    }
}
