//
//  EntryContentView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import SnapKit

class EntryContentView: UIStackView {
    
    var textView        = UITextView()
    var quoteTextView   = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupViews()
        self.setupLayouts()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - View Setup
    func addSubviews() {
        self.addArrangedSubview(quoteTextView)
        self.addArrangedSubview(textView)
    }
    
    func setupViews() {
        self.distribution       = .equalSpacing
        self.axis               = .vertical
        self.alignment          = .leading
        
        quoteTextView.font              = UIFont.systemFont(ofSize: 15)
        quoteTextView.isEditable        = false
        quoteTextView.isSelectable      = false
        quoteTextView.isScrollEnabled   = false
        quoteTextView.backgroundColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)

        textView.font               = UIFont.systemFont(ofSize: 17)
        textView.isSelectable       = true
        textView.isScrollEnabled    = false
        textView.isEditable         = false
        textView.sizeToFit()
        
    }
    
    func setupLayouts() {
        quoteTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(quoteTextView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
