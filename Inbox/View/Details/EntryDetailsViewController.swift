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
    var detailview = UIView()
    var textView = UITextView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entry: Entry?
    var entryId: UUID?
    let content = "This is a sample content"

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
        detailview.frame = view.bounds
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(detailview)
        view.addSubview(textView)
    }
    
    func setupNavigationBar() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode                    = .never
        navigationController?.navigationBar.prefersLargeTitles  = false
        navigationController?.navigationBar.isTranslucent       = false
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntry))
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setupViews() {
        textView.font               = UIFont.systemFont(ofSize: 14)
        textView.text               = entry?.content
        textView.isSelectable       = true
        textView.isScrollEnabled    = false
        textView.backgroundColor    = UIColor.blue
        
        detailview.backgroundColor  = UIColor.systemBackground
    }

    func setupLayout() {
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
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
