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
    var replyButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 48))
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entry: Entry?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupNavigationBar()
        setupMenu()
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
        view.addSubview(replyButton)
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
        
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(UIColor.white, for: .normal)
        replyButton.backgroundColor = UIColor.red
        replyButton.addTarget(self, action: #selector(self.replyTo), for: .touchUpInside)
        
    }

    func setupLayout() {
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        replyButton.snp.makeConstraints{ (make) in
            make.top.equalTo(textView).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(50)
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
            }
        } catch {
            print("Get entry failed...")
        }
    }
    
    @objc func edit(entry: Entry) {
        
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
            reply.replyTo = self.entry!
            
            self.entry!.addToReplies(reply)
            
            // Save the new reply
            do {
                try self.context.save()
            } catch {
                print("Save reply failed...")
            }
            
            self.fetchEntry()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    
    @objc func quote(){
        print("Quotep pressed...")
    }

}
