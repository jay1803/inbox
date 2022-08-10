//
//  EntryDetailsViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/7/26.
//

import UIKit
import SnapKit
import CoreData

class EntryDetailsViewController: UIViewController, UITableViewDelegate {

    // MARK: - Property
//    var stackView       = UIStackView()
    var detailView      = UIView()
    
    var textView        = EntryContentView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var parentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var parentsDataSource     = parentsDataSourceConfig()
    
    var replyToLeftBoard = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var repliesTableView    = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var repliesDataSource     = repliesDataSourceConfig()
    
    var replyButton     = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 48))
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entry: Entry?
    var parentEntries: [Entry]?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntry()
        
        addSubviews()
        setupNavigationBar()
        setupMenu()
        setupViews()
        setupLayout()
        
        if entry?.replyTo != nil {
            self.parentEntries = getReplyTo(of: entry!)
            parentTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.left.equalTo(replyToLeftBoard.snp.right)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(parentEntries!.count * 80)
            }
        }
        
        if let replies = entry?.replies {
            repliesTableView.snp.remakeConstraints { (make) in
                make.width.equalTo(view)
                make.top.equalTo(textView.snp.bottom)
                make.height.equalTo(80 * replies.count)
            }
        }
        
        repliesTableView.register(EntryRepliesTableViewCell.self, forCellReuseIdentifier: EntryRepliesTableViewCell.identifier)
        repliesTableView.delegate = self
        repliesTableView.dataSource = repliesDataSource
        
        parentTableView.register(ParentEntriesTableViewCell.self, forCellReuseIdentifier: ParentEntriesTableViewCell.identifier)
        parentTableView.delegate = self
        parentTableView.dataSource = parentsDataSource
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchEntry()
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(detailView)
        view.addSubview(textView)
        view.addSubview(replyButton)
        view.addSubview(replyToLeftBoard)
        view.addSubview(repliesTableView)
        view.addSubview(parentTableView)
    }
    
    func setupNavigationBar() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode                    = .never
        navigationController?.navigationBar.prefersLargeTitles  = false
        navigationController?.navigationBar.isTranslucent       = true
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(self.editEntry))
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setupViews() {
        detailView.backgroundColor = UIColor.systemBackground
        
        textView.content = entry?.content
        textView.quote   = entry?.quote
        textView.backgroundColor = UIColor.red
        
        replyToLeftBoard.backgroundColor = UIColor.gray
        
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(UIColor.white, for: .normal)
        replyButton.backgroundColor = UIColor.red
        replyButton.addTarget(self, action: #selector(self.replyTo), for: .touchUpInside)
        
    }

    func setupLayout() {
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(parentTableView.snp.bottom).offset(20)
            make.width.equalTo(view)
            make.height.equalTo(200)
        }
        
        parentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(replyToLeftBoard.snp.right)
            make.right.equalTo(view)
        }
        
        replyToLeftBoard.snp.makeConstraints { (make) in
            make.top.equalTo(parentTableView)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(parentTableView.snp.height)
            make.width.equalTo(4)
        }
        
        replyButton.snp.makeConstraints{ (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(40)
        }
        
        repliesTableView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.width.equalTo(view)
        }
    }
    
    func setupMenu() {
        let quote = UIMenuItem(title: "Quote", action: #selector(self.quote))
        let menu = UIMenuController.shared
        menu.menuItems = [quote]
    }

    // MARK: - Private
    func fetchEntry() {
        
        do {
            guard let entry = entry else {
                return
            }

            let request = Entry.fetchRequest() as NSFetchRequest<Entry>
            let pred = NSPredicate(format: "%K == %@", "id", entry.id! as CVarArg)
            request.predicate = pred
            self.entry = try context.fetch(request).first
            DispatchQueue.main.async {
                self.textView.reloadInputViews()
                if let replies = entry.replies {
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Entry>()
                    snapshot.appendSections([.all])
                    snapshot.appendItems(self.entry!.replies!.allObjects as! [Entry], toSection: .all)
                    self.repliesDataSource.apply(snapshot)
                    self.repliesTableView.reloadData()
                }
                if let parentEntry = entry.replyTo {
                    self.parentEntries = self.getReplyTo(of: entry)
                    var parentSnapshot = NSDiffableDataSourceSnapshot<Section, Entry>()
                    parentSnapshot.appendSections([.all])
                    parentSnapshot.appendItems(self.parentEntries!, toSection: .all)
                    self.parentsDataSource.apply(parentSnapshot)
                    self.parentTableView.reloadData()
                }
            }
        } catch {
            print("Get entry failed...")
        }
    }
    
    func getReplyTo(of item: Entry) -> [Entry] {
        var items: [Entry] = []
        guard let parentEntry = item.replyTo else { return items }
        items.append(parentEntry)
        if let grandEntry = parentEntry.replyTo {
            items.append(contentsOf: getReplyTo(of: parentEntry))
        }
        return items
    }
    
    @objc func editEntry() {
        print("Pressed edit button...")
        let alert = UIAlertController(title: "Edit entry", message: "Edit entry", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textFiled: UITextField!) -> Void in
            textFiled.text = self.entry?.content
        })
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfiled = alert.textFields![0]
            self.entry?.content = textfiled.text
            
            do {
                try self.context.save()
            } catch {
                print("Edit note error...")
            }
            
            self.fetchEntry()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func replyWith(_ reply: Entry) {
        reply.replyTo = self.entry!
        self.entry!.addToReplies(reply)
        
        // Save the new reply
        do {
            try self.context.save()
            self.fetchEntry()
        } catch {
            print("Save reply failed...")
        }
    }
    
    @objc func replyTo() {
        let alert = UIAlertController(title: "Reply to", message: "Reply to current note", preferredStyle: .alert)
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfiled = alert.textFields![0]
            let reply = Entry(context: self.context)
            reply.id = UUID()
            reply.content = textfiled.text
            reply.createdAt = Date()
            reply.updatedAt = reply.createdAt
            
            self.replyWith(reply)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    
    @objc func quote(){
        guard let textRange = textView.textView.selectedTextRange else { return }
        guard let selectedText = textView.textView.text(in: textRange) else { return }
        
        let alert = UIAlertController(title: "Reply with quote", message: "\(selectedText)", preferredStyle: .alert)
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfiled = alert.textFields![0]
            let reply = Entry(context: self.context)
            reply.id = UUID()
            reply.content = textfiled.text
            reply.createdAt = Date()
            reply.updatedAt = reply.createdAt
            reply.quote = selectedText
            
            self.replyWith(reply)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Reply list
    
    func repliesDataSourceConfig() -> UITableViewDiffableDataSource<Section, Entry> {
        let cellIdentifier = EntryRepliesTableViewCell.identifier
        let dataSource = UITableViewDiffableDataSource<Section, Entry>(tableView: repliesTableView, cellProvider: {tableView, indexPath, entry in
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryRepliesTableViewCell.identifier, for: indexPath) as! EntryRepliesTableViewCell
            
            // TODO: Convert createdAt to String
            cell.createdAtLabel.text    = entry.content
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
    
    func parentsDataSourceConfig() -> UITableViewDiffableDataSource<Section, Entry> {
        let cellIdentifier = ParentEntriesTableViewCell.identifier
        let dataSource = UITableViewDiffableDataSource<Section, Entry>(tableView: parentTableView, cellProvider: {tableView, indexPath, entry in
            let cell = tableView.dequeueReusableCell(withIdentifier: ParentEntriesTableViewCell.identifier, for: indexPath) as! ParentEntriesTableViewCell
            
            // TODO: Convert createdAt to String
            cell.createdAtLabel.text    = entry.content
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == parentTableView {
            guard let parentEntries = self.parentEntries else { return 0 }
            return parentEntries.count
        }
        if tableView == repliesTableView {
            guard let replies = self.entry?.replies else { return 0 }
            return replies.count
        }
        return 0
    }

}
