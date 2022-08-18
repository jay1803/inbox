//
//  ViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/6/26.
//

import UIKit
import CoreData
import SnapKit

enum Section {
    case all
}

class EntryListViewController: UIViewController, UITableViewDelegate, UITextViewDelegate {
    
    // MARK: - Property
    var path = NSHomeDirectory()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Entry]?
    var keyboardSize = CGRect(x: 0, y: 0, width: 0, height: 0)
    var safeArea: CGFloat = 32
    lazy var dataSource = configureDataSource()
    
    private var listView   = UIView()
    private var tableView   = UITableView()
    private var editorView  = EntryEditorView()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntries()
        
        addSubviews()
        setupNavigationBar()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEntries()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(listView)
        listView.addSubview(tableView)
        listView.addSubview(editorView)
    }
    
    func setupNavigationBar() {
        title = "Home"
        navigationItem.largeTitleDisplayMode                    = .always
        navigationController?.navigationBar.prefersLargeTitles  = true
        navigationController?.navigationBar.isTranslucent       = true
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntry))
        
        self.navigationItem.leftBarButtonItem   = editButton
    }
    
    func setupViews() {
        listView.frame  = view.bounds
        listView.backgroundColor    = UIColor.systemBackground
        
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .singleLine
        
        if view.traitCollection.userInterfaceStyle == .dark {
            editorView.backgroundColor = UIColor.black
        } else {
            editorView.backgroundColor = UIColor(red: 214/255, green: 217/255, blue: 222/255, alpha: 1)
        }
        
        editorView.sendButton.addTarget(self, action: #selector(self.addEntry), for: .touchUpInside)
        editorView.textView.delegate    = self
    }

    
    func setupLayout() {
    }
    
    func updateLayout() {
        tableView.frame.size.height     = screenSize.height - 94
        tableView.frame.size.width      = screenSize.width
        
        editorView.frame.size.height    = 60
        editorView.frame.size.width     = screenSize.width
        editorView.frame.origin.y       = screenSize.height - 94
        
        listView.frame.size.height      = screenSize.height
        listView.frame.size.width       = screenSize.width
    }
    
    // MARK: - Private
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboard will hide...")
        keyboardSize    = CGRect(x: 0, y: 0, width: 0, height: 0)
        safeArea        = 32
        editorView.frame.origin.y = screenSize.height - keyboardSize.height - editorView.frame.height - safeArea
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will shown.....")
        guard let keyboardBounds = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardSize = keyboardBounds
        safeArea    = 0
        editorView.frame.origin.y = screenSize.height - keyboardSize.height - editorView.frame.height - safeArea
    }

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
        guard let content = editorView.textView.text else { return }
        
        // Create a Entry object
        let newEntry = Entry(context: self.context)
        newEntry.id = UUID()
        newEntry.content = content
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
        editorView.textView.text        = ""
        editorView.frame.size.height    = 60
        editorView.frame.origin.y       = screenSize.height - keyboardSize.height - editorView.frame.height - safeArea
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
        let viewController = DetailViewController()
        viewController.entry = entry
        navigationController?.pushViewController(viewController, animated: true)
        editorView.textView.endEditing(true)
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
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("should end editing...")
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Did begin editing...")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("Did change...")
        editorView.frame.size.height    = textView.contentSize.height + 23
        editorView.frame.origin.y       = screenSize.height - editorView.frame.size.height - keyboardSize.height - safeArea
    }
}
