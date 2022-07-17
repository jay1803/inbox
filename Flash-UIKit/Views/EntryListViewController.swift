//
//  ViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/6/26.
//

import UIKit

class EntryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    let data = ["one", "two", "three"]
    
    private var entryList: UITableView = UITableView()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(entryList)
        
        setupNavigationBar()
        
        entryList.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.identifier)
        
        entryList.delegate = self
        entryList.dataSource = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        entryList.frame = view.bounds
    }
    
    // MARK: - ViewSetup
    
    func setupNavigationBar() {
        title = "Home"
        navigationItem.largeTitleDisplayMode = .always
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntries))
        let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(EntryListViewController.addEntry))
        
        self.navigationItem.leftBarButtonItem = editButton
        self.navigationItem.rightBarButtonItem = addButton
    }

    
    func setupLayout() {
        
    }
    
    // MARK: - Private
    @objc func addEntry() {
        
    }
    
    @objc func editEntries() {
        
    }
    
    func getData() {
        
    }
    
    func handleData() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
        cell.contentLabel.text = data[indexPath.row]
        cell.createdAtLabel.text = "today"
        cell.repliesCountLabel.text = "0"
        return cell
    }
}
