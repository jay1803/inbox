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
    var scrollview      = UIScrollView()
    var stackView       = UIStackView()
    
    var contentView     = EntryContentView()
    lazy var replyView       = EntryRepliesView()
    lazy var replyToView     = EntryReplyToView()
    
    var parentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var parentsDataSource     = parentsDataSourceConfig()

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
        
        if entry?.quote == nil {
            contentView.quoteTextView.isHidden = true
        }
        
        if entry?.replyTo == nil {
            replyToView.isHidden = true
        }
        
        if entry?.replies == nil {
            replyView.isHidden = true
        }

        parentTableView.register(ParentEntriesTableViewCell.self, forCellReuseIdentifier: ParentEntriesTableViewCell.identifier)
        parentTableView.delegate = self
        parentTableView.dataSource = parentsDataSource
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollview.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchEntry()
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(scrollview)
        scrollview.addSubview(stackView)
        stackView.addArrangedSubview(replyToView)
        stackView.addArrangedSubview(contentView)
        stackView.addArrangedSubview(replyView)
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
        scrollview.isScrollEnabled          = true
        scrollview.isDirectionalLockEnabled = true
        scrollview.contentSize              = stackView.bounds.size
        scrollview.backgroundColor          = UIColor.systemBackground
        scrollview.sizeToFit()
        
        stackView.backgroundColor   = UIColor.systemBackground
        stackView.axis              = .vertical
        stackView.distribution      = .equalSpacing
        stackView.spacing           = 10
        stackView.alignment         = .fill
        stackView.sizeToFit()
        
        contentView.quoteTextView.text   = entry?.quote
        contentView.textView.text = entry?.content
        
        replyToView.backgroundColor = UIColor.blue
        
        replyView.backgroundColor   = UIColor.green
        if let replies = entry?.replies {
            replyView.items         = replies.allObjects as! [Entry]
            replyView.frame.size    = replyView.tableView.contentSize
        }
    }

    func setupLayout() {
        scrollview.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(stackView)
        }
        
        replyToView.snp.makeConstraints { (make) in
            make.width.equalTo(stackView)
            make.height.equalTo(50)
        }
        
        replyView.snp.makeConstraints { (make) in
            make.width.equalTo(stackView)
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
                self.contentView.reloadInputViews()
                if let replies = entry.replies {
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Entry>()
                    snapshot.appendSections([.all])
                    snapshot.appendItems(self.entry!.replies!.allObjects as! [Entry], toSection: .all)
                    self.replyView.dataSource.apply(snapshot)
                    self.replyView.items = replies.allObjects as! [Entry]
                    self.replyView.tableView.sizeThatFits(self.replyView.tableView.contentSize)
                    self.replyView.snp.remakeConstraints { (make) in
                        make.height.equalTo(self.replyView.tableView.contentSize.height)
                    }
                    self.replyView.tableView.snp.remakeConstraints { (make) in
                        make.top.left.right.bottom.equalToSuperview()
                    }
                    self.replyView.tableView.reloadData()
                }
                if entry.replyTo != nil {
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
        if parentEntry.replyTo != nil {
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
        guard let textRange = contentView.textView.selectedTextRange else { return }
        guard let selectedText = contentView.textView.text(in: textRange) else { return }
        
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
    
    func parentsDataSourceConfig() -> UITableViewDiffableDataSource<Section, Entry> {
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
        return 0
    }

}
