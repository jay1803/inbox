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
        self.distribution       = .fill
        self.axis               = .vertical
        self.alignment          = .leading
        self.spacing            = UIStackView.spacingUseSystem
        
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins           = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        
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
        
    }
    
    func setupLayouts() {
        quoteTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}
