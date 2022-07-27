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
    var content: String = "This is a sample content"

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(textView)
    }
    
    func setupNavigationBar() {
        title = "Detail"
    }
    
    func setupViews() {
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = content
        textView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
    }

    func setupLayout() {
        textView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }

    // MARK: - Private
    func getEntryBy(id entryId: String) {
        
        do {
            let request = Entry.fetchRequest() as NSFetchRequest<Entry>
            let pred = NSPredicate(format: "id == \(entryId)")
            request.predicate = pred
            self.entry = try context.fetch(request).first
        } catch {
            print("Get entry failed...")
        }
    }

}
