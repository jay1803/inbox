//
//  EntryContentView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import SnapKit

class ContentView: UIStackView {
    
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
        self.addArrangedSubview(textView)
        self.addArrangedSubview(quoteTextView)
    }
    
    func setupViews() {
        self.distribution       = .equalSpacing
        self.axis               = .vertical
        self.alignment          = .leading
        
        quoteTextView.font                  = UIFont.systemFont(ofSize: 15)
        quoteTextView.isEditable            = false
        quoteTextView.isSelectable          = false
        quoteTextView.isScrollEnabled       = false
        quoteTextView.contentInset          = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        quoteTextView.layer.borderWidth     = 1
        quoteTextView.layer.borderColor     = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        quoteTextView.layer.cornerRadius    = 10

        textView.font               = UIFont.systemFont(ofSize: 17)
        textView.isSelectable       = true
        textView.isScrollEnabled    = false
        textView.isEditable         = false
        textView.contentInset       = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
    func setupLayouts() {
        textView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        quoteTextView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
