//
//  EntryTableViewCell.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/6/26.
//

import UIKit
import SnapKit

class EntryTableViewCell: UITableViewCell {
    
    static let identifier = "EntryTableViewCell"
    var contentLabel      = UILabel()
    var createdAtLabel    = UILabel()
    var repliesCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        
        addSubviews()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Setup view
    func addSubviews() {
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(createdAtLabel)
        self.contentView.addSubview(repliesCountLabel)
    }
    
    func setupView() {
        createdAtLabel.font    = UIFont.systemFont(ofSize: 12)
        repliesCountLabel.font = UIFont.systemFont(ofSize: 12)
        createdAtLabel.textColor = UIColor.gray
        repliesCountLabel.textColor = UIColor.gray
        
        contentLabel.numberOfLines = 3
        contentLabel.lineBreakMode = .byTruncatingTail
    }
    
    func setupLayout() {
        createdAtLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(repliesCountLabel).offset(-20)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.right.bottom.equalTo(self.contentView).offset(-20)
            make.top.equalTo(createdAtLabel).offset(20)
        }
        
        repliesCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createdAtLabel)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }

}
