//
//  EntryRepliesView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import SnapKit

class EntryRepliesView: UIView, UITableViewDelegate {

    // MARK: - Property
    var tableView = UITableView()
    lazy var dataSource = self.dataSourceConfig()
    lazy var items: [Entry] = []


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupViews()
        self.setupLayout()
        
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewSetup
    func addSubviews() {
        self.addSubview(tableView)
    }

    func setupViews() {
        tableView.isScrollEnabled   = false
    }

    func setupLayout() {
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Private
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func dataSourceConfig() -> UITableViewDiffableDataSource<Section, Entry> {
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

}
