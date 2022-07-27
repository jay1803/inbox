//
//  EntryDetailsViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/7/26.
//

import UIKit
import SnapKit
import CoreData

class EntryDetailsViewController: UIViewController {

    // MARK: - Property
    var textView = UITextView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entry: Entry?
    var entryId: UUID?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupNavigationBar()
        setupViews()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = view.bounds
        fetchEntry()
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(textView)
    }
    
    func setupNavigationBar() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntry))
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setupViews() {
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = entry?.content
        textView.backgroundColor = UIColor.blue
    }

    func setupLayout() {
        textView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }

    // MARK: - Private
    func fetchEntry() {
        
        do {
            let request = Entry.fetchRequest() as NSFetchRequest<Entry>
            let pred = NSPredicate(format: "id == \(entry?.id)")
            request.predicate = pred
            self.entry = try context.fetch(request).first
            DispatchQueue.main.async {
                self.textView.reloadInputViews()
            }
        } catch {
            print("Get entry failed...")
        }
    }
    
    @objc func edit(entry: Entry) {
        
    }

}
